<#
.SYNOPSIS
  Pull Ollama models in parallel on Windows.
.DESCRIPTION
  * Можно передать JSON‑файл с моделью, либо использовать встроенный список.
  * Ограничение количества одновременных задач задаётся `-ParallelJobs`.
#>

param(
    [string]$JsonFile = "",
    [int]$ParallelJobs = 0
)

# -------------------------------------------------------------------------
# 1️⃣  Проверяем наличие `ollama`
# -------------------------------------------------------------------------
if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {
    Write-Error "'ollama' command not found. Install Ollama for Windows first."
    exit 1
}

# -------------------------------------------------------------------------
# 2️⃣  Проверяем JSON‑файл (если передан)
# -------------------------------------------------------------------------
if ($JsonFile -ne "" -and -not (Test-Path $JsonFile)) {
    Write-Error "JSON file '$JsonFile' does not exist."
    exit 1
}

# -------------------------------------------------------------------------
# 3️⃣  Формируем список моделей
# -------------------------------------------------------------------------
if ($JsonFile -ne "") {
    $json = Get-Content $JsonFile -Raw | ConvertFrom-Json
    $models = $json.integrations.opencode.models
} else {
    # Встроенный список (проверьте, совпадает с вашим JSON)
    $models = @(
        "glm-4.7-flash:q4_K_M",
        "gemma3n:e4b",
        "gemma3n:e2b",
        "gemma3:4b",
        "gemma3:27b",
        "gemma3:270m",
        "gemma3:1b",
        "gemma3:12b",
        "functiongemma:270m",
        "embeddinggemma",
        "devstral-small-2:24b",
        "deepseek-r1:8b",
        "deepseek-r1:7b",
        "deepseek-r1:70b",
        "deepseek-r1:32b",
        "deepseek-r1:14b",
        "deepseek-r1:1.5b",
        "glm-ocr:bf16",
        "gpt-oss:20b",
        "granite4:1b",
        "granite4:350m",
        "granite4:3b",
        "lfm2.5-thinking:1.2b",
        "ministral-3:14b",
        "ministral-3:3b",
        "ministral-3:8b",
        "nemotron-3-nano:30b",
        "olmo-3.1:32b",
        "qwen2.5-coder:0.5b",
        "qwen2.5-coder:1.5b",
        "qwen2.5-coder:14b",
        "qwen2.5-coder:32b",
        "qwen2.5-coder:3b",
        "qwen2.5-coder:7b",
        "qwen3-coder-next:q4_K_M",
        "qwen3-coder:30b",
        "qwen3-embedding:0.6b",
        "qwen3-embedding:4b",
        "qwen3-embedding:8b",
        "qwen3-next:80b",
        "qwen3-vl:2b",
        "qwen3-vl:30b",
        "qwen3-vl:32b",
        "qwen3-vl:4b",
        "qwen3-vl:8b",
        "qwen3:0.6b",
        "qwen3:1.7b",
        "qwen3:4b",
        "rnj-1:8b",
        "translategemma:27b"
    )
}

# -------------------------------------------------------------------------
# 4️⃣  Функция, которая скачивает одну модель
# -------------------------------------------------------------------------
function Invoke-ModelPull {
    param([string]$Model)

    $ts = Get-Date -Format "HH:mm:ss"
    Write-Host "[$ts] Starting pull for: $Model"

    try {
        ollama pull $Model

        if ($LASTEXITCODE -ne 0) {
            Write-Error ("[{0}] Pull failed for {1} with exit code {2}" -f $ts, $Model, $LASTEXITCODE)
        } else {
            Write-Host "[$ts] Finished pull for: $Model"
        }
    } catch {
        # Получаем сообщение исключения
        $msg = $_.Exception.Message
        Write-Error ("[{0}] Exception pulling {1}: {2}" -f $ts, $Model, $msg)
    }
}

# -------------------------------------------------------------------------
# 5️⃣  Запускаем задачи в фоне, с возможным ограничением количества
# -------------------------------------------------------------------------
$jobs = @()

foreach ($model in $models) {
    # Ограничиваем количество одновременных задач (если указано)
    while ($ParallelJobs -gt 0 -and ($jobs | Where-Object { $_.State -eq 'Running' }).Count -ge $ParallelJobs) {
        Start-Sleep -Milliseconds 200
    }

    # Запускаем задачу в фоне
    $jobs += Start-Job -ScriptBlock ${function:Invoke-ModelPull} -ArgumentList $model
}

# -------------------------------------------------------------------------
# 6️⃣  Ожидаем завершения всех задач и выводим их вывод
# -------------------------------------------------------------------------
Write-Host "Waiting for all pulls to finish..."

Wait-Job $jobs

foreach ($job in $jobs) {
    Receive-Job $job -Keep | Out-Host
    Remove-Job $job
}

Write-Host "All model pulls have completed."
