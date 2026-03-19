param(
    [string]$ProjectRoot,
    [switch]$InstallExtensions
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "UnrealHelpers.ps1")

function Write-JsonFile {
    param(
        [string]$Path,
        [object]$Content
    )

    $json = $Content | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText($Path, $json + [Environment]::NewLine)
}

$projectInfo = Get-UnrealProjectInfo -ProjectRoot $ProjectRoot
$engineRoot = Get-UnrealEngineRoot -ProjectRoot $projectInfo.ProjectRoot
$dotNetExe = Get-UnrealDotNetExe -EngineRoot $engineRoot
$dotNetRoot = Set-UnrealDotNetEnvironment -DotNetExe $dotNetExe
$compilerPath = Get-MSVCCompilerPath
$editorPath = Get-UnrealEditorPath -ProjectRoot $projectInfo.ProjectRoot
$natvisPath = Get-UnrealNatvisPath -ProjectRoot $projectInfo.ProjectRoot
$vscodeDir = Join-Path $projectInfo.ProjectRoot ".vscode"
$sourceFileMap = [ordered]@{
    "D:\build\++UE5\Sync" = $engineRoot
    "Z:\UEVFS\$($projectInfo.ProjectName)" = $projectInfo.ProjectRoot
    "Z:\UEVFS\Root" = $engineRoot
}

if (-not (Test-Path $vscodeDir)) {
    New-Item -ItemType Directory -Path $vscodeDir | Out-Null
}

Invoke-UnrealBuildTool -ProjectRoot $projectInfo.ProjectRoot -Arguments @(
    "-Mode=GenerateClangDatabase",
    (Get-UnrealTargetName -ProjectRoot $projectInfo.ProjectRoot -Kind "Editor"),
    "Win64",
    "Development",
    "-Project=$($projectInfo.UProjectPath)",
    "-OutputDir=$vscodeDir",
    "-OutputFilename=compile_commands.json"
)

$settings = [ordered]@{
    "C_Cpp.default.compileCommands" = '${workspaceFolder}\.vscode\compile_commands.json'
    "C_Cpp.default.compilerPath" = $compilerPath
    "C_Cpp.default.intelliSenseMode" = "msvc-x64"
    "C_Cpp.default.cppStandard" = "c++20"
    "C_Cpp.default.cStandard" = "c17"
    "files.associations" = [ordered]@{
        "*.Build.cs" = "csharp"
        "*.Target.cs" = "csharp"
        "*.generated.h" = "cpp"
        "*.inl" = "cpp"
        "*.usf" = "cpp"
        "*.ush" = "cpp"
    }
    "files.exclude" = [ordered]@{
        "**/.git" = $true
        "**/Binaries" = $true
        "**/DerivedDataCache" = $true
        "**/Intermediate" = $true
        "**/Saved" = $true
    }
    "search.exclude" = [ordered]@{
        "**/Binaries" = $true
        "**/DerivedDataCache" = $true
        "**/Intermediate" = $true
        "**/Saved" = $true
    }
    "files.watcherExclude" = [ordered]@{
        "**/Binaries/**" = $true
        "**/DerivedDataCache/**" = $true
        "**/Intermediate/**" = $true
        "**/Saved/**" = $true
    }
    "terminal.integrated.defaultProfile.windows" = "PowerShell"
    "terminal.integrated.env.windows" = [ordered]@{
        "PATH" = "$dotNetRoot;" + '${env:PATH}'
        "DOTNET_ROOT" = $dotNetRoot
        "DOTNET_HOST_PATH" = $dotNetExe
        "DOTNET_MULTILEVEL_LOOKUP" = "0"
        "DOTNET_ROLL_FORWARD" = "LatestMajor"
    }
}

$cCppProperties = [ordered]@{
    configurations = @(
        [ordered]@{
            name = "$($projectInfo.ProjectName) Editor Win64 Development"
            compilerPath = $compilerPath
            cStandard = "c17"
            cppStandard = "c++20"
            intelliSenseMode = "msvc-x64"
            compileCommands = (Join-Path $vscodeDir "compile_commands.json")
        }
    )
}

$tasks = [ordered]@{
    version = "2.0.0"
    tasks = @(
        [ordered]@{
            label = "Unreal: Setup VS Code"
            type = "shell"
            command = "powershell.exe"
            args = @(
                "-ExecutionPolicy", "Bypass",
                "-File", '${workspaceFolder}\Scripts\Unreal\Setup-VSCode.ps1'
            )
            options = [ordered]@{
                cwd = '${workspaceFolder}'
            }
            problemMatcher = @()
        },
        [ordered]@{
            label = "Unreal: Refresh IntelliSense Database"
            type = "shell"
            command = "powershell.exe"
            args = @(
                "-ExecutionPolicy", "Bypass",
                "-File", '${workspaceFolder}\Scripts\Unreal\Invoke-Unreal.ps1',
                "-Action", "GenerateClangDatabase"
            )
            options = [ordered]@{
                cwd = '${workspaceFolder}'
            }
            problemMatcher = @()
        },
        [ordered]@{
            label = "Unreal: Build Editor (Development)"
            type = "shell"
            command = "powershell.exe"
            args = @(
                "-ExecutionPolicy", "Bypass",
                "-File", '${workspaceFolder}\Scripts\Unreal\Invoke-Unreal.ps1',
                "-Action", "Build",
                "-Target", "Editor",
                "-Configuration", "Development"
            )
            options = [ordered]@{
                cwd = '${workspaceFolder}'
            }
            problemMatcher = '$msCompile'
            group = [ordered]@{
                kind = "build"
                isDefault = $true
            }
        },
        [ordered]@{
            label = "Unreal: Clean Editor (Development)"
            type = "shell"
            command = "powershell.exe"
            args = @(
                "-ExecutionPolicy", "Bypass",
                "-File", '${workspaceFolder}\Scripts\Unreal\Invoke-Unreal.ps1',
                "-Action", "Clean",
                "-Target", "Editor",
                "-Configuration", "Development"
            )
            options = [ordered]@{
                cwd = '${workspaceFolder}'
            }
            problemMatcher = '$msCompile'
        },
        [ordered]@{
            label = "Unreal: Build Game (Development)"
            type = "shell"
            command = "powershell.exe"
            args = @(
                "-ExecutionPolicy", "Bypass",
                "-File", '${workspaceFolder}\Scripts\Unreal\Invoke-Unreal.ps1',
                "-Action", "Build",
                "-Target", "Game",
                "-Configuration", "Development"
            )
            options = [ordered]@{
                cwd = '${workspaceFolder}'
            }
            problemMatcher = '$msCompile'
        },
        [ordered]@{
            label = "Unreal: Launch Editor"
            type = "shell"
            command = "powershell.exe"
            args = @(
                "-ExecutionPolicy", "Bypass",
                "-File", '${workspaceFolder}\Scripts\Unreal\Invoke-Unreal.ps1',
                "-Action", "LaunchEditor"
            )
            options = [ordered]@{
                cwd = '${workspaceFolder}'
            }
            dependsOn = @("Unreal: Build Editor (Development)")
            problemMatcher = @()
        },
        [ordered]@{
            label = "Unreal: Start Editor (Build + Launch)"
            type = "shell"
            command = "powershell.exe"
            args = @(
                "-ExecutionPolicy", "Bypass",
                "-File", '${workspaceFolder}\Scripts\Unreal\Start-UnrealEditor.ps1'
            )
            options = [ordered]@{
                cwd = '${workspaceFolder}'
            }
            problemMatcher = @()
        },
        [ordered]@{
            label = "Unreal: Rebuild and Launch Editor"
            type = "shell"
            command = "powershell.exe"
            args = @(
                "-ExecutionPolicy", "Bypass",
                "-File", '${workspaceFolder}\Scripts\Unreal\Start-UnrealEditor.ps1',
                "-Clean",
                "-RefreshIntelliSense"
            )
            options = [ordered]@{
                cwd = '${workspaceFolder}'
            }
            problemMatcher = @()
        }
    )
}

$launch = [ordered]@{
    version = "0.2.0"
    configurations = @(
        [ordered]@{
            name = "Attach to Unreal Editor"
            type = "cppvsdbg"
            request = "attach"
            processId = '${command:pickProcess}'
            visualizerFile = $natvisPath
            sourceFileMap = $sourceFileMap
        },
        [ordered]@{
            name = "Launch Unreal Editor (Development)"
            type = "cppvsdbg"
            request = "launch"
            program = $editorPath
            args = @($projectInfo.UProjectPath)
            cwd = $engineRoot
            stopAtEntry = $false
            console = "integratedTerminal"
            preLaunchTask = "Unreal: Build Editor (Development)"
            visualizerFile = $natvisPath
            sourceFileMap = $sourceFileMap
        }
    )
}

$extensions = [ordered]@{
    recommendations = @(
        "ms-vscode.cpptools",
        "ms-vscode.cpptools-extension-pack",
        "ms-dotnettools.csharp",
        "ms-vscode.powershell"
    )
}

$workspace = [ordered]@{
    folders = @(
        [ordered]@{
            name = $projectInfo.ProjectName
            path = "."
        }
    )
    settings = [ordered]@{
        "C_Cpp.default.compileCommands" = '${workspaceFolder:' + $projectInfo.ProjectName + '}\.vscode\compile_commands.json'
        "C_Cpp.default.compilerPath" = $compilerPath
    }
    extensions = [ordered]@{
        recommendations = $extensions.recommendations
    }
}

Write-JsonFile -Path (Join-Path $vscodeDir "settings.json") -Content $settings
Write-JsonFile -Path (Join-Path $vscodeDir "c_cpp_properties.json") -Content $cCppProperties
Write-JsonFile -Path (Join-Path $vscodeDir "tasks.json") -Content $tasks
Write-JsonFile -Path (Join-Path $vscodeDir "launch.json") -Content $launch
Write-JsonFile -Path (Join-Path $vscodeDir "extensions.json") -Content $extensions
Write-JsonFile -Path (Join-Path $projectInfo.ProjectRoot "$($projectInfo.ProjectName).code-workspace") -Content $workspace

if ($InstallExtensions) {
    $codeCommand = Get-Command code -ErrorAction SilentlyContinue
    if (-not $codeCommand) {
        throw "The VS Code command line tool 'code' is not available on PATH."
    }

    foreach ($extension in $extensions.recommendations) {
        & $codeCommand.Source --install-extension $extension --force | Out-Host
        if ($LASTEXITCODE -ne 0) {
            throw "Installing VS Code extension '$extension' failed with exit code $LASTEXITCODE."
        }
    }
}

Write-Host "VS Code Unreal setup completed."
Write-Host "Project: $($projectInfo.ProjectName)"
Write-Host "Engine:  $engineRoot"
Write-Host "Compiler: $compilerPath"
Write-Host "Compile DB: $(Join-Path $vscodeDir 'compile_commands.json')"
