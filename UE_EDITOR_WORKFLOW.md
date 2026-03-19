# Unreal Editor Workflow from VS Code and VS Code-Based IDEs

This guide covers the day-to-day Unreal workflow from:

- Visual Studio Code
- Antigravity
- Other editors that use the VS Code task and launch model

The goal is to give you the same practical basics you would expect from an IDE like Rider:

- build the Unreal editor target
- clean and rebuild when needed
- launch the editor from the IDE
- attach a debugger
- refresh IntelliSense after C++ changes
- keep the setup repeatable across machines

## Files Added for This Workflow

The main workflow scripts are:

- `Scripts/Unreal/UnrealHelpers.ps1`
- `Scripts/Unreal/Invoke-Unreal.ps1`
- `Scripts/Unreal/Start-UnrealEditor.ps1`
- `Scripts/Unreal/Setup-VSCode.ps1`

The editor integration files are:

- `.vscode/settings.json`
- `.vscode/tasks.json`
- `.vscode/launch.json`
- `.vscode/compile_commands.json`
- `FMP.code-workspace`

## What Each Script Does

### `Setup-VSCode.ps1`

Use this when setting up the project on a new machine or after Unreal/Visual Studio changes.

It:

- detects the Unreal install from the `.uproject`
- finds the local MSVC compiler
- sets the Unreal `.NET` environment for the terminal
- regenerates `.vscode/compile_commands.json`
- rewrites the `.vscode` config files

Command:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Setup-VSCode.ps1
```

Optional extension install:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Setup-VSCode.ps1 -InstallExtensions
```

### `Invoke-Unreal.ps1`

This is the lower-level wrapper for individual actions.

Supported actions:

- `Build`
- `Clean`
- `GenerateClangDatabase`
- `LaunchEditor`

Examples:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Invoke-Unreal.ps1 -Action Build -Target Editor -Configuration Development
```

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Invoke-Unreal.ps1 -Action GenerateClangDatabase
```

### `Start-UnrealEditor.ps1`

This is the convenience script for the common "Rider-like" flow:

- compile the editor target
- optionally clean first
- optionally refresh IntelliSense
- launch Unreal Editor

Default behavior:

- build editor target
- launch Unreal Editor

Command:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Start-UnrealEditor.ps1
```

Clean rebuild and refresh IntelliSense before launch:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Start-UnrealEditor.ps1 -Clean -RefreshIntelliSense
```

Launch editor without compiling:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Start-UnrealEditor.ps1 -SkipBuild
```

Compile and refresh IntelliSense without launching the editor:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Start-UnrealEditor.ps1 -RefreshIntelliSense -NoLaunch
```

## VS Code Tasks

After running setup, the following tasks are available in the editor:

- `Unreal: Setup VS Code`
- `Unreal: Refresh IntelliSense Database`
- `Unreal: Build Editor (Development)`
- `Unreal: Clean Editor (Development)`
- `Unreal: Build Game (Development)`
- `Unreal: Launch Editor`
- `Unreal: Start Editor (Build + Launch)`
- `Unreal: Rebuild and Launch Editor`

These roughly map to the actions most people expect from Rider:

- build current editor target
- rebuild project
- run editor from inside the IDE
- keep code model / IntelliSense up to date

## Recommended Daily Workflow

### Normal Unreal C++ iteration

Use:

- `Unreal: Start Editor (Build + Launch)`

This is the closest "one click compile and run editor" workflow.

### After changing modules, build settings, or generated code behavior

Use:

- `Unreal: Rebuild and Launch Editor`

This:

- cleans the editor target
- recompiles it
- refreshes `.vscode/compile_commands.json`
- launches Unreal Editor

### If IntelliSense gets out of sync

Use:

- `Unreal: Refresh IntelliSense Database`

That regenerates the compile database Unreal C++ IntelliSense depends on.

## Debugging

The launch file includes:

- `Launch Unreal Editor (Development)`
- `Attach to Unreal Editor`

### When to use `Launch Unreal Editor (Development)`

Use this when you want to start the editor under the debugger from the IDE.

### When to use `Attach to Unreal Editor`

Use this when:

- the editor is already open
- you started Unreal outside the IDE
- you only want to attach for a specific debugging session

The debugger configuration uses Unreal's `Unreal.natvis` file for better Unreal C++ type display.

## Antigravity and Other VS Code-Based IDEs

If your editor supports standard VS Code workspace files, this setup should mostly work without changes.

What the editor needs to support:

- `.vscode/tasks.json`
- `.vscode/launch.json`
- `.vscode/settings.json`
- `compile_commands.json`

If it does not support the Microsoft extension marketplace directly, install the equivalents manually for:

- C++
- PowerShell
- C# for `.Build.cs` and `.Target.cs`

The most important requirement for Unreal code navigation is still:

- the compiler path
- the compile database
- generated headers under `Intermediate`

## Useful Command-Line Workflows

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

### Build and launch editor

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Start-UnrealEditor.ps1
```

### Clean rebuild and launch editor

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Start-UnrealEditor.ps1 -Clean -RefreshIntelliSense
```

## Notes

Unreal's normal VS Code project generation can try to write files inside the engine install, which is not reliable on a launcher-installed Unreal build under `Program Files`.

That is why this workflow relies on project-local `.vscode` files and UnrealBuildTool's `GenerateClangDatabase` mode instead.

If Unreal, Visual Studio, or the engine path changes on another machine, rerun:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Scripts\Unreal\Setup-VSCode.ps1
```

That will rebuild the editor configuration for the new machine.
