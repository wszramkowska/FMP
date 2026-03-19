Set-StrictMode -Version Latest

function Get-ProjectRoot {
    param(
        [string]$ProjectRoot
    )

    if ($ProjectRoot) {
        return (Resolve-Path $ProjectRoot).Path
    }

    return (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
}

function Get-UProjectFile {
    param(
        [string]$ProjectRoot
    )

    $resolvedRoot = Get-ProjectRoot -ProjectRoot $ProjectRoot
    $uproject = Get-ChildItem -Path $resolvedRoot -Filter *.uproject -File | Select-Object -First 1

    if (-not $uproject) {
        throw "No .uproject file was found in '$resolvedRoot'."
    }

    return $uproject.FullName
}

function Get-UnrealProjectInfo {
    param(
        [string]$ProjectRoot
    )

    $resolvedRoot = Get-ProjectRoot -ProjectRoot $ProjectRoot
    $uprojectPath = Get-UProjectFile -ProjectRoot $resolvedRoot
    $uproject = Get-Content -Raw $uprojectPath | ConvertFrom-Json

    return [pscustomobject]@{
        ProjectRoot       = $resolvedRoot
        UProjectPath      = $uprojectPath
        ProjectName       = [System.IO.Path]::GetFileNameWithoutExtension($uprojectPath)
        EngineAssociation = [string]$uproject.EngineAssociation
    }
}

function Get-UnrealEngineRoot {
    param(
        [string]$ProjectRoot
    )

    $projectInfo = Get-UnrealProjectInfo -ProjectRoot $ProjectRoot
    $candidates = New-Object System.Collections.Generic.List[string]

    if ($env:UE_ENGINE_ROOT) {
        $candidates.Add($env:UE_ENGINE_ROOT)
    }

    if ($projectInfo.EngineAssociation) {
        $buildsKey = "HKCU:\Software\Epic Games\Unreal Engine\Builds"
        if (Test-Path $buildsKey) {
            $builds = Get-ItemProperty $buildsKey
            $matchingBuild = $builds.PSObject.Properties | Where-Object { $_.Name -eq $projectInfo.EngineAssociation } | Select-Object -First 1
            if ($matchingBuild -and $matchingBuild.Value) {
                $candidates.Add([string]$matchingBuild.Value)
            }
        }
    }

    foreach ($candidate in $candidates) {
        if (-not $candidate) {
            continue
        }

        $resolvedCandidate = (Resolve-Path $candidate).Path
        $buildBat = Join-Path $resolvedCandidate "Engine\Build\BatchFiles\Build.bat"
        if (Test-Path $buildBat) {
            return $resolvedCandidate
        }
    }

    throw "Unable to resolve the Unreal Engine install for association '$($projectInfo.EngineAssociation)'."
}

function Get-UnrealDotNetExe {
    param(
        [string]$EngineRoot
    )

    $dotNetRoot = Join-Path $EngineRoot "Engine\Binaries\ThirdParty\DotNet"
    $dotNetExe = Get-ChildItem -Path $dotNetRoot -Filter dotnet.exe -Recurse -File | Select-Object -First 1

    if (-not $dotNetExe) {
        throw "Unable to find Unreal's bundled dotnet.exe under '$dotNetRoot'."
    }

    return $dotNetExe.FullName
}

function Get-UnrealBuildToolDll {
    param(
        [string]$EngineRoot
    )

    $ubtPath = Join-Path $EngineRoot "Engine\Binaries\DotNET\UnrealBuildTool\UnrealBuildTool.dll"
    if (-not (Test-Path $ubtPath)) {
        throw "Unable to find UnrealBuildTool at '$ubtPath'."
    }

    return $ubtPath
}

function Set-UnrealDotNetEnvironment {
    param(
        [string]$DotNetExe
    )

    $dotNetRoot = Split-Path -Parent $DotNetExe
    $env:DOTNET_ROOT = $dotNetRoot
    $env:DOTNET_HOST_PATH = $DotNetExe
    $env:DOTNET_MULTILEVEL_LOOKUP = "0"
    $env:DOTNET_ROLL_FORWARD = "LatestMajor"

    $pathParts = $env:PATH -split ";"
    if ($pathParts -notcontains $dotNetRoot) {
        $env:PATH = "$dotNetRoot;$($env:PATH)"
    }

    return $dotNetRoot
}

function Invoke-UnrealBuildTool {
    param(
        [string]$ProjectRoot,
        [string[]]$Arguments
    )

    $engineRoot = Get-UnrealEngineRoot -ProjectRoot $ProjectRoot
    $dotNetExe = Get-UnrealDotNetExe -EngineRoot $engineRoot
    $ubtPath = Get-UnrealBuildToolDll -EngineRoot $engineRoot

    Set-UnrealDotNetEnvironment -DotNetExe $dotNetExe | Out-Null
    & $dotNetExe $ubtPath @Arguments

    if ($LASTEXITCODE -ne 0) {
        throw "UnrealBuildTool failed with exit code $LASTEXITCODE."
    }
}

function Get-UnrealEditorPath {
    param(
        [string]$ProjectRoot
    )

    $engineRoot = Get-UnrealEngineRoot -ProjectRoot $ProjectRoot
    $editorPath = Join-Path $engineRoot "Engine\Binaries\Win64\UnrealEditor.exe"

    if (-not (Test-Path $editorPath)) {
        throw "Unable to find UnrealEditor.exe at '$editorPath'."
    }

    return $editorPath
}

function Get-UnrealNatvisPath {
    param(
        [string]$ProjectRoot
    )

    $engineRoot = Get-UnrealEngineRoot -ProjectRoot $ProjectRoot
    $natvisPath = Join-Path $engineRoot "Engine\Extras\VisualStudioDebugging\Unreal.natvis"

    if (-not (Test-Path $natvisPath)) {
        throw "Unable to find Unreal.natvis at '$natvisPath'."
    }

    return $natvisPath
}

function Get-MSVCCompilerPath {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
    if (-not (Test-Path $vswhere)) {
        throw "Unable to find vswhere.exe at '$vswhere'."
    }

    $installationPath = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    if (-not $installationPath) {
        throw "Unable to find a Visual Studio installation with the desktop C++ workload."
    }

    $toolRoot = Join-Path $installationPath "VC\Tools\MSVC"
    $compiler = Get-ChildItem -Path $toolRoot -Filter cl.exe -Recurse -File |
        Where-Object { $_.FullName -like "*\bin\Hostx64\x64\cl.exe" } |
        Sort-Object FullName -Descending |
        Select-Object -First 1

    if (-not $compiler) {
        throw "Unable to find cl.exe under '$toolRoot'."
    }

    return $compiler.FullName
}

function Get-UnrealTargetName {
    param(
        [string]$ProjectRoot,
        [ValidateSet("Game", "Editor")]
        [string]$Kind = "Editor"
    )

    $projectInfo = Get-UnrealProjectInfo -ProjectRoot $ProjectRoot
    if ($Kind -eq "Editor") {
        return "$($projectInfo.ProjectName)Editor"
    }

    return $projectInfo.ProjectName
}
