#!/usr/bin/with-contenv bashio
# ==============================================================================
# Moltbot Add-on Startup Script
# ==============================================================================

bashio::log.info "Starting Moltbot Add-on..."

# Read configuration from Home Assistant
AGENT_MODEL=$(bashio::config 'agent_model')
ANTHROPIC_API_KEY=$(bashio::config 'anthropic_api_key')
OPENAI_API_KEY=$(bashio::config 'openai_api_key')
TELEGRAM_BOT_TOKEN=$(bashio::config 'telegram_bot_token')
TELEGRAM_REQUIRE_MENTION=$(bashio::config 'telegram_require_mention')
WHATSAPP_ENABLED=$(bashio::config 'whatsapp_enabled')
DISCORD_BOT_TOKEN=$(bashio::config 'discord_bot_token')
SLACK_BOT_TOKEN=$(bashio::config 'slack_bot_token')
SLACK_APP_TOKEN=$(bashio::config 'slack_app_token')
SANDBOX_MODE=$(bashio::config 'sandbox_mode')
LOG_LEVEL=$(bashio::config 'log_level')

# Create moltbot config directory
CONFIG_DIR="/config/moltbot"
mkdir -p "${CONFIG_DIR}"

# Build moltbot.json configuration
bashio::log.info "Generating Moltbot configuration..."

# Start building the JSON config
CONFIG_JSON=$(jq -n \
    --arg model "${AGENT_MODEL}" \
    --arg sandbox "${SANDBOX_MODE}" \
    --arg log_level "${LOG_LEVEL}" \
    '{
        agent: {
            model: $model
        },
        agents: {
            defaults: {
                sandbox: {
                    mode: $sandbox
                }
            }
        },
        logging: {
            level: $log_level
        },
        channels: {}
    }')

# Add Telegram configuration if token is provided
if bashio::var.has_value "${TELEGRAM_BOT_TOKEN}"; then
    bashio::log.info "Configuring Telegram channel..."

    # Get allowed groups as JSON array
    TELEGRAM_GROUPS=$(bashio::config 'telegram_allowed_groups')

    CONFIG_JSON=$(echo "${CONFIG_JSON}" | jq \
        --arg token "${TELEGRAM_BOT_TOKEN}" \
        --argjson require_mention "${TELEGRAM_REQUIRE_MENTION}" \
        --argjson groups "${TELEGRAM_GROUPS}" \
        '.channels.telegram = {
            botToken: $token,
            groups: ($groups | if length > 0 then (reduce .[] as $g ({}; .[$g] = {requireMention: $require_mention})) else {} end)
        }')
fi

# Add Discord configuration if token is provided
if bashio::var.has_value "${DISCORD_BOT_TOKEN}"; then
    bashio::log.info "Configuring Discord channel..."

    DISCORD_SERVERS=$(bashio::config 'discord_allowed_servers')

    CONFIG_JSON=$(echo "${CONFIG_JSON}" | jq \
        --arg token "${DISCORD_BOT_TOKEN}" \
        --argjson servers "${DISCORD_SERVERS}" \
        '.channels.discord = {
            botToken: $token,
            servers: $servers
        }')
fi

# Add Slack configuration if tokens are provided
if bashio::var.has_value "${SLACK_BOT_TOKEN}"; then
    bashio::log.info "Configuring Slack channel..."

    CONFIG_JSON=$(echo "${CONFIG_JSON}" | jq \
        --arg bot_token "${SLACK_BOT_TOKEN}" \
        --arg app_token "${SLACK_APP_TOKEN}" \
        '.channels.slack = {
            botToken: $bot_token,
            appToken: $app_token
        }')
fi

# Add WhatsApp configuration if enabled
if bashio::var.true "${WHATSAPP_ENABLED}"; then
    bashio::log.info "Enabling WhatsApp channel..."

    CONFIG_JSON=$(echo "${CONFIG_JSON}" | jq \
        '.channels.whatsapp = {
            enabled: true
        }')
fi

# Write configuration file
echo "${CONFIG_JSON}" > "${CONFIG_DIR}/moltbot.json"
bashio::log.info "Configuration written to ${CONFIG_DIR}/moltbot.json"

# Export environment variables for API keys
if bashio::var.has_value "${ANTHROPIC_API_KEY}"; then
    export ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}"
    bashio::log.info "Anthropic API key configured"
fi

if bashio::var.has_value "${OPENAI_API_KEY}"; then
    export OPENAI_API_KEY="${OPENAI_API_KEY}"
    bashio::log.info "OpenAI API key configured"
fi

# Set moltbot home directory
export MOLTBOT_HOME="${CONFIG_DIR}"
export CLAWDBOT_HOME="${CONFIG_DIR}"

# Create symlink for standard config location
mkdir -p ~/.clawdbot
ln -sf "${CONFIG_DIR}/moltbot.json" ~/.clawdbot/moltbot.json

bashio::log.info "Starting Moltbot gateway..."

# Start moltbot with the gateway command
exec moltbot gateway --config "${CONFIG_DIR}/moltbot.json"
