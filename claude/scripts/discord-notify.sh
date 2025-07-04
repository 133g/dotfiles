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

# イベントタイプを取得
EVENT_TYPE=$(echo "$INPUT" | jq -r '.event // "unknown"')

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