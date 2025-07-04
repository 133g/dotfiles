#!/bin/bash

# Discord通知スクリプト
# Claude Code hooksから呼び出される

# 設定
DISCORD_WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-""}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../discord-config.json"

# Discord Webhook URLを設定ファイルから読み込み
if [[ -f "$CONFIG_FILE" && -z "$DISCORD_WEBHOOK_URL" ]]; then
    DISCORD_WEBHOOK_URL=$(jq -r '.webhook_url // empty' "$CONFIG_FILE" 2>/dev/null)
fi

# Webhook URLが設定されていない場合は終了
if [[ -z "$DISCORD_WEBHOOK_URL" ]]; then
    echo "Discord Webhook URL is not configured" >&2
    exit 1
fi

# 標準入力からJSONデータを読み取り
INPUT=$(cat)

# デバッグ用: 受信したJSONをログに記録
echo "DEBUG: Received JSON: $INPUT" >> /tmp/claude-hooks-debug.log

# イベントタイプを推定（JSONの構造から判定）
if echo "$INPUT" | jq -e '.hook_event_name' > /dev/null 2>&1; then
    EVENT_TYPE=$(echo "$INPUT" | jq -r '.hook_event_name')
    echo "DEBUG: Detected event type from .hook_event_name: $EVENT_TYPE" >> /tmp/claude-hooks-debug.log
elif echo "$INPUT" | jq -e '.message' > /dev/null 2>&1; then
    EVENT_TYPE="Notification"
    echo "DEBUG: Detected as Notification (has .message)" >> /tmp/claude-hooks-debug.log
elif echo "$INPUT" | jq -e '.event' > /dev/null 2>&1; then
    EVENT_TYPE=$(echo "$INPUT" | jq -r '.event')
    echo "DEBUG: Detected event type from .event field: $EVENT_TYPE" >> /tmp/claude-hooks-debug.log
else
    EVENT_TYPE="unknown"
    echo "DEBUG: Could not detect event type, defaulting to unknown" >> /tmp/claude-hooks-debug.log
fi

echo "DEBUG: Final EVENT_TYPE: $EVENT_TYPE" >> /tmp/claude-hooks-debug.log

# メッセージの構築
case "$EVENT_TYPE" in
    "Stop")
        TITLE="🛑 Claude Code Session Stopped"
        DESCRIPTION="Claude Code session has been stopped"
        COLOR="15158332" # 赤色
        ;;
    "Notification")
        TITLE="📢 Claude Code Notification"
        DESCRIPTION=$(echo "$INPUT" | jq -r '.message // "Notification received"')
        COLOR="3447003" # 青色
        ;;
    *)
        TITLE="ℹ️ Claude Code Event"
        DESCRIPTION="Event: $EVENT_TYPE"
        COLOR="10181046" # グレー色
        ;;
esac

# 現在時刻
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")

# Discordに送信するペイロード
PAYLOAD=$(cat <<EOF
{
  "embeds": [
    {
      "title": "$TITLE",
      "description": "$DESCRIPTION",
      "color": $COLOR,
      "timestamp": "$TIMESTAMP",
      "footer": {
        "text": "Claude Code Hooks"
      },
      "fields": [
        {
          "name": "Host",
          "value": "$(hostname)",
          "inline": true
        },
        {
          "name": "Working Directory",
          "value": "$(pwd)",
          "inline": true
        }
      ]
    }
  ]
}
EOF
)

# Discordに送信
curl -s -H "Content-Type: application/json" \
     -X POST \
     -d "$PAYLOAD" \
     "$DISCORD_WEBHOOK_URL" > /dev/null

if [[ $? -eq 0 ]]; then
    echo "Discord notification sent successfully"
else
    echo "Failed to send Discord notification" >&2
    exit 1
fi