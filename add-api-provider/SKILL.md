---
name: add-api-provider
description: Use when user asks to add, configure, or register a new API provider or model provider in opencode. Covers OpenAI-compatible, Anthropic-compatible, and other custom providers. Trigger on phrases like "添加 provider", "add API provider", "配置自定义模型", "添加 API".
---

# Add API Provider

Add a custom model API provider to opencode's configuration.

## Prerequisites

- Provider must support OpenAI-compatible chat completions format (most providers)
- API endpoint URL
- API key (if required)

## Workflow

### Step 1: Locate config

Determine config scope:

| Scope | Path |
|-------|------|
| Global | `~/.config/opencode/opencode.json` or `opencode.jsonc` |
| Project | `./opencode.json` or `.opencode/opencode.json` |

Use global config unless user specifies project.

```powershell
Test-Path -LiteralPath "$env:USERPROFILE/.config/opencode/opencode.jsonc"
Test-Path -LiteralPath "opencode.json"
```

### Step 2: Query available models

```powershell
Invoke-RestMethod -Uri "https://api.example.com/v1/models" -Headers @{ "Authorization" = "Bearer <API_KEY>" } -Method Get | ConvertTo-Json -Depth 10
```

Extract model `id` fields from the response `data` array.

### Step 3: Build config

Create or update config with:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "<provider>/<default-model>",
  "provider": {
    "<provider-name>": {
      "options": {
        "apiKey": "<API_KEY>",
        "baseURL": "https://api.example.com/v1"
      },
      "models": {
        "<model-id-1>": {
          "id": "<model-id-1>",
          "name": "<Display Name>"
        },
        "<model-id-2>": {
          "id": "<model-id-2>",
          "name": "<Display Name>"
        }
      }
    }
  }
}
```

Key points:
- `model` sets the default model: `<provider-name>/<model-id>`
- `options.baseURL` must end with `/v1` for OpenAI-compatible providers
- `models` is required — opencode will not list models without explicit declarations
- Provider name (key under `provider`) is arbitrary but used as prefix in `provider/model-id`

### Step 4: Write config

Use `Write` tool to write the file. If both `.json` and `.jsonc` exist, prefer `.jsonc` in global scope.

After saving, remind user to restart opencode.

## Model metadata (optional)

Extended model config:

```json
"<model-id>": {
  "id": "<model-id>",
  "name": "<Display Name>",
  "modalities": { "input": ["text", "image"], "output": ["text"] },
  "limit": { "context": 128000, "output": 4096 },
  "cost": { "input": 0.001, "output": 0.002 }
}
```

## Troubleshooting

**Models not showing in /models list:**
- Confirm `models` block is present and non-empty
- Check for JSON syntax errors in config
- Verify `options.baseURL` is correct and accessible

**API errors:**
- Confirm `options.baseURL` ends with `/v1` (not `/v1/chat/completions`)
- Verify API key is correct
- Check if provider requires additional headers