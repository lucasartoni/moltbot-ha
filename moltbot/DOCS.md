# Moltbot Home Assistant Add-on

Moltbot is a self-hosted personal AI assistant that connects to multiple messaging platforms while keeping full control on your Home Assistant instance.

## Features

- **Multi-platform messaging**: Connect to Telegram, WhatsApp, Discord, Slack, and more
- **AI-powered**: Uses Claude or GPT models for intelligent responses
- **Self-hosted**: Your data stays on your Home Assistant instance
- **Sandboxed execution**: Run group conversations in isolated containers for security

## Configuration

### Required Settings

You need to configure at least one AI provider API key:

- **Anthropic API Key**: Get your key from [Anthropic Console](https://console.anthropic.com/)
- **OpenAI API Key**: Get your key from [OpenAI Platform](https://platform.openai.com/)

### Agent Configuration

| Option | Description | Default |
|--------|-------------|---------|
| `agent_model` | The AI model to use (e.g., `anthropic/claude-opus-4-5`, `openai/gpt-4o`) | `anthropic/claude-opus-4-5` |
| `sandbox_mode` | Sandbox mode: `off`, `main`, or `non-main` | `non-main` |
| `log_level` | Logging verbosity: `debug`, `info`, `warn`, `error` | `info` |

### Telegram Configuration

1. Create a bot with [@BotFather](https://t.me/BotFather) on Telegram
2. Copy the bot token and paste it in `telegram_bot_token`
3. Optionally configure allowed groups and mention requirements

| Option | Description |
|--------|-------------|
| `telegram_bot_token` | Your Telegram bot token from BotFather |
| `telegram_allowed_groups` | List of group IDs allowed to use the bot |
| `telegram_require_mention` | Require @mention in groups to respond |

### Discord Configuration

1. Create a Discord application at [Discord Developer Portal](https://discord.com/developers/applications)
2. Create a bot and copy the token
3. Add the bot to your server with appropriate permissions

| Option | Description |
|--------|-------------|
| `discord_bot_token` | Your Discord bot token |
| `discord_allowed_servers` | List of server IDs allowed to use the bot |

### Slack Configuration

1. Create a Slack app at [Slack API](https://api.slack.com/apps)
2. Enable Socket Mode and get the app-level token
3. Add the bot to your workspace

| Option | Description |
|--------|-------------|
| `slack_bot_token` | Your Slack bot token (xoxb-...) |
| `slack_app_token` | Your Slack app token (xapp-...) |

### WhatsApp Configuration

| Option | Description |
|--------|-------------|
| `whatsapp_enabled` | Enable WhatsApp integration (requires additional setup) |

## Security

### Sandbox Mode

The sandbox mode controls how Moltbot handles tool execution:

- **off**: No sandboxing, full access (not recommended)
- **main**: Sandbox main/personal sessions
- **non-main**: Sandbox group conversations only (recommended)

### DM Pairing

By default, unknown senders in DMs receive a pairing code instead of immediate bot access. This prevents unauthorized access to your AI assistant.

## Ports

| Port | Description |
|------|-------------|
| 18789 | WebSocket Control Plane |

## Data Storage

- Configuration: `/config/moltbot/`
- Data: `/data/`

## Troubleshooting

### Bot not responding

1. Check the add-on logs for errors
2. Verify your API keys are correct
3. Ensure the bot token is valid
4. Check if the bot has proper permissions in your chat platform

### WhatsApp issues

WhatsApp requires additional setup and may need QR code scanning. Check the logs for the QR code or pairing instructions.

## Support

- [Moltbot GitHub](https://github.com/moltbot/moltbot)
- [Home Assistant Community](https://community.home-assistant.io/)
