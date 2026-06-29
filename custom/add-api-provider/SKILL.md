---
name: add-api-provider
description: Use when user asks to add, configure, or register a new API provider or model provider in opencode. This skill is essential whenever someone mentions connecting an external AI service — whether it's OpenAI-compatible, Anthropic-compatible, a custom endpoint, or any LLM provider. Trigger phrases include "添加 provider", "add API provider", "配置自定义模型", "添加 API", "配置 API key", "setup provider", "连接新模型", or any request to extend opencode with new AI services. Don't wait to be asked explicitly — if the conversation involves connecting external AI services, invoke this skill proactively.
---

# Add API Provider

Add a custom model API provider to opencode's configuration. This skill walks you through understanding what the provider needs, finding the right configuration, and setting it up correctly the first time.

## When to use this skill

- User wants to add a new AI provider (OpenAI, Anthropic, local models, etc.)
- User mentions configuring API keys or endpoints for AI services
- User asks to connect a custom or self-hosted model
- User wants to add models not pre-configured in opencode

## Prerequisites

Before starting, confirm you have:

- **OpenAI-compatible chat completions format** — Most providers support this, including OpenAI, Anthropic (via OpenAI-compatible mode), local models via LM Studio, Ollama, etc.
- **API endpoint URL** — Usually something like `https://api.example.com/v1`
- **API key** — If the provider requires authentication

If the user isn't sure whether their provider is compatible, ask them to confirm.

## Workflow

### Step 1: Locate config

Find the appropriate config file. The location determines whether the provider is available system-wide or only in a specific project.

| Scope | Path | When to use |
|-------|------|-------------|
| Global | `~/.config/opencode/opencode.json` or `opencode.jsonc` | User wants provider available everywhere |
| Project | `./opencode.json` or `.opencode/opencode.json` | User wants per-project provider |

For most cases, global config is the right choice. Project config is useful when different projects need different providers.

```powershell
Test-Path -LiteralPath "$env:USERPROFILE/.config/opencode/opencode.jsonc"
Test-Path -LiteralPath "opencode.json"
```

If neither exists, you'll create a new config file. Use `.jsonc` extension (JSON with comments) for readability.

### Step 2: Query available models

Before configuring, it's helpful to know what models the provider offers. This ensures you configure them correctly and can give the user accurate options.

```powershell
Invoke-RestMethod -Uri "https://api.example.com/v1/models" -Headers @{ "Authorization" = "Bearer <API_KEY>" } -Method Get | ConvertTo-Json -Depth 10
```

Look for the `data` array in the response. Each object has an `id` field — that's the model identifier you'll use in the config.

If the API doesn't support listing models (some don't), skip this step and ask the user which model they want to configure.

### Step 3: Build config

Create or update the config with this structure:

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

**Key points to understand:**

- `model` sets the default model as `<provider-name>/<model-id>`. This is what opencode will use if the user doesn't specify a model.
- `options.baseURL` must end with `/v1` for OpenAI-compatible providers. This is the most common mistake — don't include the full `/v1/chat/completions` path.
- `models` is required — opencode won't list models without explicit declarations. Each model needs at minimum an `id` field matching the provider's model identifier.
- The provider name (key under `provider`) is arbitrary — it's used as a prefix in `provider/model-id` combinations. Use something recognizable like "openai", "anthropic", "local".

### Step 4: Write config

Use the Write tool to create or update the file:

- If both `.json` and `.jsonc` exist in the target location, prefer `.jsonc`
- Preserve the existing content if updating — only add the `provider` section and update `model`

After saving, remind the user to **restart opencode** for changes to take effect.

## Model metadata (optional)

For a better experience, you can add metadata about each model:

```json
"<model-id>": {
  "id": "<model-id>",
  "name": "<Display Name>",
  "modalities": { "input": ["text", "image"], "output": ["text"] },
  "limit": { "context": 128000, "output": 4096 },
  "cost": { "input": 0.001, "output": 0.002 }
}
```

- `modalities` — What the model accepts and returns. Helps opencode show appropriate options.
- `limit` — Context window size and output limits. Useful for users to know constraints.
- `cost` — Cost per 1M tokens (input/output). Helps users estimate spending.

## Troubleshooting

**Models not appearing in `/models` list:**
1. Confirm the `models` block is present and non-empty
2. Check for JSON syntax errors (trailing commas, unquoted keys)
3. Verify `options.baseURL` is correct and the endpoint is accessible
4. Try calling the API directly to confirm it responds

**API errors when using the model:**
1. Confirm `options.baseURL` ends with `/v1` — not `/v1/chat/completions` or other paths
2. Verify the API key is correct and has necessary permissions
3. Check if the provider requires additional headers (some need `Content-Type`, etc.)

**Provider not connecting at all:**
1. Confirm the provider supports OpenAI-compatible format
2. Check if the API requires a different auth method (some use Bearer tokens differently)
3. Verify network connectivity to the endpoint