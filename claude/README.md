# Claude Code Discord Notifications

This setup enables Discord notifications for Claude Code events using hooks.

## Files

- `scripts/discord-notify.sh` - Main notification script
- `scripts/setup-discord.sh` - Setup script for webhook configuration
- `discord-config.json` - Discord webhook configuration
- `settings.json` - Claude Code hooks configuration

## Setup

1. Create a Discord Webhook:
   - Go to your Discord server settings
   - Navigate to Integrations > Webhooks
   - Create a new webhook and copy the URL

2. Run the setup script:
   ```bash
   ~/.claude/scripts/setup-discord.sh
   ```

3. Enter your Discord webhook URL when prompted

## Testing

Test the notification manually:
```bash
echo '{"event":"Stop"}' | ~/.claude/scripts/discord-notify.sh
```

## Events

The following Claude Code events will trigger Discord notifications:

- **Stop**: When a Claude Code session ends
- **Notification**: When Claude Code sends a notification

## Configuration

Edit `discord-config.json` to change the webhook URL:
```json
{
  "webhook_url": "https://discord.com/api/webhooks/YOUR_WEBHOOK_URL"
}
```

## Notification Format

Notifications include:
- Event type with appropriate emoji and color
- Timestamp
- Hostname
- Working directory
- Event-specific details

## Requirements

- `curl` - for sending HTTP requests
- `jq` - for JSON processing
- Valid Discord webhook URL