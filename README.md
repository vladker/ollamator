# Ollama Model Puller

PowerShell script to pull Ollama models in parallel on Windows.

## Usage

### Basic Usage
```powershell
# Pull default models
.\pull_models.ps1

# Pull models from a custom JSON file
.\pull_models.ps1 -JsonFile models.json

# Pull models with parallel jobs limit
.\pull_models.ps1 -JsonFile models.json -ParallelJobs 5
```

## JSON Configuration

The script supports custom JSON configuration files to specify which models to pull. Here's an example structure:

```json
{
  "integrations": {
    "opencode": {
      "models": [
        "glm-4.7-flash:q4_K_M",
        "gemma3n:e4b",
        "gemma3n:e2b"
      ]
    }
  }
}
```

## Parameters

- `-JsonFile` (optional): Path to a JSON file containing the models to pull
- `-ParallelJobs` (optional): Maximum number of parallel jobs to run (default: unlimited)

## Requirements

- PowerShell 5.1 or higher
- Ollama installed on Windows