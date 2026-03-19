param(
    [string]$ProjectRoot,
    [switch]$SkipBuild,
    [switch]$Clean,
    [switch]$RefreshIntelliSense,
    [switch]$NoLaunch
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "UnrealHelpers.ps1")

$projectInfo = Get-UnrealProjectInfo -ProjectRoot $ProjectRoot
$engineRoot = Get-UnrealEngineRoot -ProjectRoot $projectInfo.ProjectRoot
$editorTarget = Get-UnrealTargetName -ProjectRoot $projectInfo.ProjectRoot -Kind "Editor"
$editorPath = Get-UnrealEditorPath -ProjectRoot $projectInfo.ProjectRoot

if ($Clean) {
    $cleanBat = Join-Path $engineRoot "Engine\Build\BatchFiles\Clean.bat"
    & $cleanBat $editorTarget "Win64" "Development" $projectInfo.UProjectPath "-waitmutex"
    if ($LASTEXITCODE -ne 0) {
        throw "Clean failed with exit code $LASTEXITCODE."
    }
}

if (-not $SkipBuild) {
    $buildBat = Join-Path $engineRoot "Engine\Build\BatchFiles\Build.bat"
    & $buildBat $editorTarget "Win64" "Development" $projectInfo.UProjectPath "-waitmutex"
    if ($LASTEXITCODE -ne 0) {
        throw "Build failed with exit code $LASTEXITCODE."
    }
}

if ($RefreshIntelliSense) {
    $vscodeDir = Join-Path $projectInfo.ProjectRoot ".vscode"
    if (-not (Test-Path $vscodeDir)) {
        New-Item -ItemType Directory -Path $vscodeDir | Out-Null
    }

    Invoke-UnrealBuildTool -ProjectRoot $projectInfo.ProjectRoot -Arguments @(
        "-Mode=GenerateClangDatabase",
        $editorTarget,
        "Win64",
        "Development",
        "-Project=$($projectInfo.UProjectPath)",
        "-OutputDir=$vscodeDir",
        "-OutputFilename=compile_commands.json"
    )
}

if (-not $NoLaunch) {
    Start-Process -FilePath $editorPath -ArgumentList @($projectInfo.UProjectPath) | Out-Null
}
