# Unreal C++ Environment Setup for VS Code and VS Code-Based IDEs

This document explains what was set up in this repository, what was validated on this machine, and how to repeat the same setup on another Windows machine.

It applies to:

- Visual Studio Code
- Antigravity
- Other editors built on the VS Code workspace model that understand `.vscode`, `tasks.json`, `launch.json`, and `compile_commands.json`

## What Was Done in This Repo

The Unreal C++ environment was set up around the project itself instead of relying on Unreal's one-off generated VS Code files.

The following scripts were added:

- `Scripts/Unreal/UnrealHelpers.ps1`
- `Scripts/Unreal/Invoke-Unreal.ps1`
- `Scripts/Unreal/Setup-VSCode.ps1`

The following editor files were generated or refreshed:

- `.vscode/settings.json`
- `.vscode/c_cpp_properties.json`
- `.vscode/tasks.json`
- `.vscode/launch.json`
- `.vscode/extensions.json`
- `.vscode/compile_commands.json`
- `FMP.code-workspace`

## What These Scripts Do

### `UnrealHelpers.ps1`

This script detects the local Unreal and compiler setup. It:

- Finds the project `.uproject`
- Reads the Unreal `EngineAssociation` from the `.uproject`
- Resolves the engine install from the registry key `HKCU:\Software\Epic Games\Unreal Engine\Builds`
- Allows an override with the `UE_ENGINE_ROOT` environment variable
- Finds Unreal's bundled `.NET`
- Finds `UnrealBuildTool.dll`
- Finds the local Visual Studio C++ compiler
- Finds `UnrealEditor.exe`
- Finds `Unreal.natvis`

### `Invoke-Unreal.ps1`

This is the main wrapper used by VS Code tasks. It supports:

- `Build`
- `Clean`
- `GenerateClangDatabase`
- `LaunchEditor`

This means the editor does not need hardcoded machine-specific batch file paths in every task.

### `Setup-VSCode.ps1`

This is the one-shot setup script. It:

- Detects the local Unreal install and compiler
- Sets terminal `.NET` variables so Unreal tools run correctly
- Generates a project-local `compile_commands.json`
- Writes VS Code settings, tasks, launch configs, and extension recommendations
- Writes the workspace file
- Optionally installs recommended extensions if run with `-InstallExtensions`

## Why This Approach Was Used

Unreal's normal `-projectfiles -vscode` flow worked only partly on this machine.

The problem was that Unreal tried to write a `.vscode` folder inside the engine install:

- `C:\Program Files\Epic Games\5.6\.vscode`

That fails on a normal launcher-installed Unreal build because `Program Files` is not writable for regular project workflows.

To avoid that, the setup uses UnrealBuildTool's `GenerateClangDatabase` mode instead. That writes:

- `.vscode/compile_commands.json`

inside the project, which is the part VS Code IntelliSense needs most.

## What Was Validated on This Machine

The following local dependencies were found and validated:

- Unreal Engine 5.6 at `C:\Program Files\Epic Games\5.6`
- Visual Studio 2022 Community with C++ tools
- Windows 10 SDK `10.0.22621.0`
- Unreal bundled .NET SDK `8.0.300`
- Unreal natvis debugger file

The following editor extensions were available after setup:

- `ms-vscode.cpptools`
- `ms-vscode.cpptools-extension-pack`
- `ms-dotnettools.csharp`
- `ms-vscode.powershell`

The following commands were validated successfully:

- Generate Unreal compile database
- Build `FMPEditor Win64 Development`
- Run the new wrapper-based build flow from `Scripts/Unreal/Invoke-Unreal.ps1`

## How to Repeat This on Another Machine

## 1. Install Unreal Engine

Install the Unreal Engine version required by the project.

For this repo, the `.uproject` currently points to an engine association that resolved to Unreal 5.6 on this machine.

After installation, make sure the project opens in that engine version at least once so the engine association is correct.

## 2. Install Visual Studio 2022 C++ Build Tools

Install Visual Studio 2022 with the Desktop C++ workload.

Recommended components:

- Desktop development with C++
- MSVC v143 build tools
- Windows 10 or Windows 11 SDK
- C++ CMake tools for Windows
- LLVM/clang tools for Windows if available

Unreal still relies on the Visual Studio compiler toolchain even if you write code in VS Code or Antigravity.

## 3. Install a VS Code-Compatible Editor

Install one of:

- Visual Studio Code
- Antigravity
- Another VS Code-based editor

If you are using plain VS Code, also make sure the `code` command is available on `PATH` if you want automatic extension installation.

## 4. Clone or Copy the Project

Get the project onto the new machine and open the repo root.

The root should contain:

- `FMP.uproject`
- `.vscode`
- `Scripts/Unreal`

## 5. Run the Setup Script

From the project root, run:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Setup-VSCode.ps1
```

If you are using VS Code and want the script to install the recommended extensions too, run:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Setup-VSCode.ps1 -InstallExtensions
```

This will:

- Detect Unreal
- Detect the compiler
- Refresh `compile_commands.json`
- Rewrite the editor config files for that machine

## 6. Open the Workspace

Open either:

- The repo folder directly
- `FMP.code-workspace`

If the editor is fully VS Code-compatible, it should read the `.vscode` files automatically.

## 7. Build the Project

Use the task:

- `Unreal: Build Editor (Development)`

Or run the wrapper directly:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Invoke-Unreal.ps1 -Action Build -Target Editor -Configuration Development
```

## 8. Refresh IntelliSense When Needed

If you add modules, targets, or significant Unreal C++ changes, refresh the compile database with:

- `Unreal: Refresh IntelliSense Database`

Or:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Invoke-Unreal.ps1 -Action GenerateClangDatabase
```

## 9. Launch or Debug the Editor

Available launch configurations include:

- `Launch Unreal Editor (Development)`
- `Attach to Unreal Editor`

The debugger config uses Unreal's `Unreal.natvis` file and source mappings for a better Unreal debugging experience.

## Using Antigravity or Other VS Code-Based IDEs

If Antigravity supports standard VS Code workspace files, this setup should mostly work as-is because it is based on:

- `.vscode/settings.json`
- `.vscode/tasks.json`
- `.vscode/launch.json`
- `.vscode/compile_commands.json`

Things to check in Antigravity:

- It supports the Microsoft C/C++ language tooling or an equivalent C++ extension
- It respects `compile_commands.json`
- It supports VS Code tasks
- It supports VS Code launch configurations, or at least can reuse the same program paths and arguments

If Antigravity does not use the same extension marketplace, install equivalents manually for:

- C++
- C# for `.Build.cs` and `.Target.cs`
- PowerShell

The most important part for Unreal IntelliSense is still:

- A valid `compile_commands.json`
- A valid compiler path
- Unreal-generated headers in `Intermediate`

## Useful Commands

### Full setup

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Setup-VSCode.ps1
```

### Full setup plus extension install

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Setup-VSCode.ps1 -InstallExtensions
```

### Build editor target

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Invoke-Unreal.ps1 -Action Build -Target Editor -Configuration Development
```

### Build game target

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Invoke-Unreal.ps1 -Action Build -Target Game -Configuration Development
```

### Clean editor target

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Invoke-Unreal.ps1 -Action Clean -Target Editor -Configuration Development
```

### Refresh IntelliSense database

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Invoke-Unreal.ps1 -Action GenerateClangDatabase
```

### Launch Unreal Editor

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Invoke-Unreal.ps1 -Action LaunchEditor
```

## Troubleshooting

### Unreal is not detected

Check:

- The `.uproject` has a valid `EngineAssociation`
- Unreal is installed on that machine
- The registry key `HKCU:\Software\Epic Games\Unreal Engine\Builds` contains the engine mapping

If needed, set:

```powershell
$env:UE_ENGINE_ROOT="C:\Program Files\Epic Games\5.6"
```

before running setup.

### IntelliSense is missing Unreal headers

Refresh the compile database:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Invoke-Unreal.ps1 -Action GenerateClangDatabase
```

Then restart the editor window if needed.

### Build works in Unreal but not in the editor

Check:

- Visual Studio 2022 C++ workload is installed
- Windows SDK is installed
- The editor is using `.vscode/compile_commands.json`
- The compiler path in `.vscode/settings.json` is valid on that machine

Running `Setup-VSCode.ps1` again is the quickest fix.

### Extension install fails

If `-InstallExtensions` fails, the setup is still mostly usable.

In that case:

- Open the editor normally
- Install the recommended extensions manually
- Run the setup script again if needed

## Recommended Workflow

When moving this project to another machine:

1. Install Unreal Engine.
2. Install Visual Studio 2022 with C++ tools.
3. Install VS Code or Antigravity.
4. Open the project root.
5. Run `Setup-VSCode.ps1`.
6. Run `Unreal: Build Editor (Development)`.
7. Use `Unreal: Refresh IntelliSense Database` whenever Unreal C++ structure changes.

That should be enough to get Unreal C++ development, build tasks, and IntelliSense working again.
