param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Build", "Clean", "GenerateClangDatabase", "LaunchEditor")]
    [string]$Action,

    [ValidateSet("Game", "Editor")]
    [string]$Target = "Editor",

    [string]$Platform = "Win64",

    [string]$Configuration = "Development",

    [string]$ProjectRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "UnrealHelpers.ps1")

$projectInfo = Get-UnrealProjectInfo -ProjectRoot $ProjectRoot
$engineRoot = Get-UnrealEngineRoot -ProjectRoot $projectInfo.ProjectRoot
$targetName = Get-UnrealTargetName -ProjectRoot $projectInfo.ProjectRoot -Kind $Target

switch ($Action) {
    "Build" {
        $buildBat = Join-Path $engineRoot "Engine\Build\BatchFiles\Build.bat"
        & $buildBat $targetName $Platform $Configuration $projectInfo.UProjectPath "-waitmutex"
        if ($LASTEXITCODE -ne 0) {
            throw "Build failed with exit code $LASTEXITCODE."
        }
    }

    "Clean" {
        $cleanBat = Join-Path $engineRoot "Engine\Build\BatchFiles\Clean.bat"
        & $cleanBat $targetName $Platform $Configuration $projectInfo.UProjectPath "-waitmutex"
        if ($LASTEXITCODE -ne 0) {
            throw "Clean failed with exit code $LASTEXITCODE."
        }
    }

    "GenerateClangDatabase" {
        $vscodeDir = Join-Path $projectInfo.ProjectRoot ".vscode"
        if (-not (Test-Path $vscodeDir)) {
            New-Item -ItemType Directory -Path $vscodeDir | Out-Null
        }

        Invoke-UnrealBuildTool -ProjectRoot $projectInfo.ProjectRoot -Arguments @(
            "-Mode=GenerateClangDatabase",
            $targetName,
            $Platform,
            $Configuration,
            "-Project=$($projectInfo.UProjectPath)",
            "-OutputDir=$vscodeDir",
            "-OutputFilename=compile_commands.json"
        )
    }

    "LaunchEditor" {
        $editorPath = Get-UnrealEditorPath -ProjectRoot $projectInfo.ProjectRoot
        & $editorPath $projectInfo.UProjectPath
        if ($LASTEXITCODE -ne 0) {
            throw "Launching Unreal Editor failed with exit code $LASTEXITCODE."
        }
    }
}
