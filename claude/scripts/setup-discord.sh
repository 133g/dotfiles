#!/bin/bash

# Discord通知セットアップスクリプト

CONFIG_FILE="$HOME/.claude/discord-config.json"

echo "=== Claude Code Discord Notification Setup ==="
echo

# 現在の設定を確認
if [[ -f "$CONFIG_FILE" ]]; then
    CURRENT_URL=$(jq -r '.webhook_url // "Not configured"' "$CONFIG_FILE" 2>/dev/null)
    echo "Current webhook URL: $CURRENT_URL"
    echo
fi

# Webhook URLの入力
echo "Please enter your Discord Webhook URL:"
echo "(You can create one in Discord Server Settings > Integrations > Webhooks)"
echo
read -p "Webhook URL: " WEBHOOK_URL

if [[ -z "$WEBHOOK_URL" ]]; then
    echo "Error: Webhook URL cannot be empty"
    exit 1
fi

# 設定ファイルを更新
cat > "$CONFIG_FILE" <<EOF
{
  "webhook_url": "$WEBHOOK_URL"
}
EOF

echo
echo "✅ Discord notification configured successfully!"
echo
echo "Test the notification by running:"
echo "echo '{\"event\":\"Stop\"}' | $HOME/.claude/scripts/discord-notify.sh"
echo
echo "The notifications will be sent automatically when Claude Code stops or sends notifications."