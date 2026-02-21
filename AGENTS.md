# AGENTS.md

## Build Commands

This repository contains PowerShell scripts for managing Ollama models on Windows.

Build commands:
- `.\pull_models.ps1` - Pulls Ollama models from the default list
- `.\pull_models.ps1 -JsonFile models.json` - Pulls models from a custom JSON file
- `.\pull_models.ps1 -ParallelJobs 5` - Pulls models with parallel jobs limit
- `.\pull_models.ps1 -JsonFile models.json -ParallelJobs 3` - Combines custom file and parallel jobs

## Lint Commands

- Use PowerShell's built-in linter: `Get-ScriptAnalyzer -Path .\pull_models.ps1`
- Follow PowerShell best practices and style guidelines
- Maintain consistent naming conventions (PascalCase for functions, camelCase for variables)
- Use proper PowerShell comments and documentation
- Avoid hardcoded paths that aren't relative to script location

## Test Commands

This repository contains one main script that pulls models from Ollama:
- No automated tests are defined in this repository
- Testing is performed manually by running the script with various parameters
- Test by running `.\pull_models.ps1` to ensure it works with standard model list
- Test with custom JSON files to ensure the file parsing works correctly
- Run `Get-ScriptAnalyzer -Path .\pull_models.ps1` to check for code quality issues

## Code Style Guidelines

File naming:
- PowerShell scripts should use .ps1 extension
- Use PascalCase for function names
- Use camelCase for variables
- Use descriptive names for parameters (avoid single-letter parameters)

Imports:
- No external imports required for this project
- Uses built-in PowerShell cmdlets only

Formatting:
- Use 4 spaces for indentation (standard in PowerShell)
- Use consistent spacing around operators and in conditions
- Use blank lines to separate logical sections of code
- Use consistent line breaks

Types:
- PowerShell is dynamically typed; avoid explicit type declarations unless required
- Use `param()` blocks for all script parameters
- Use `-Type` for parameters when appropriate

Naming Conventions:
- Use PascalCase for function names
- Use camelCase for variables
- Use descriptive names for parameters
- Use clear and consistent naming across all files

Error Handling:
- Use `try/catch` blocks for robust error catching
- Use `Write-Error` for meaningful error messages
- Use `exit 1` when critical errors occur
- Check for required tools (e.g. `ollama`) before proceeding

Other considerations:
- All script parameters should have default values where appropriate
- Use `param()` block for parameter declaration
- Include clear documentation in script comments
- Use PowerShell v5+ features for compatibility
- Handle file paths properly with `Get-Content` and `Test-Path` functions
- Implement proper logging and progress reporting
- Validate input before processing
- Use consistent formatting throughout the script
- Use consistent error message formatting with timestamps
- Document all functions with proper comment-based help
- Use proper variable scope and avoid global variables when possible