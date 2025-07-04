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

# Claude hooks設定
SETTINGS_FILE="$HOME/.claude/settings.json"
SCRIPT_PATH="$HOME/.claude/scripts/discord-notify.sh"

echo "Setting up Claude hooks..."

# 既存のhooks設定を確認
if [[ -f "$SETTINGS_FILE" ]]; then
    # 既存の設定をバックアップ（初回のみ）
    if [[ ! -f "$SETTINGS_FILE.backup" ]]; then
        cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"
        echo "📋 Created backup of existing settings"
    fi
    
    # 新しいフォーマットでhooks設定をチェック
    STOP_HOOK_EXISTS=$(jq -r '.hooks.Stop[0].hooks[0].command // empty' "$SETTINGS_FILE" 2>/dev/null)
    NOTIFICATION_HOOK_EXISTS=$(jq -r '.hooks.Notification[0].hooks[0].command // empty' "$SETTINGS_FILE" 2>/dev/null)
    
    if [[ "$STOP_HOOK_EXISTS" == "\$HOME/.claude/scripts/discord-notify.sh" && "$NOTIFICATION_HOOK_EXISTS" == "\$HOME/.claude/scripts/discord-notify.sh" ]]; then
        echo "✅ Claude hooks are already configured correctly!"
    else
        echo "📝 Updating Claude hooks configuration..."
        
        # 新しいフォーマットでhooks設定を更新（環境変数を使用）
        jq '.hooks = {
            "Stop": [{
                "matcher": "*",
                "hooks": [{
                    "type": "command",
                    "command": "$HOME/.claude/scripts/discord-notify.sh"
                }]
            }],
            "Notification": [{
                "matcher": "*", 
                "hooks": [{
                    "type": "command",
                    "command": "$HOME/.claude/scripts/discord-notify.sh"
                }]
            }]
        }' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
        
        echo "✅ Claude hooks configured successfully! (new format)"
    fi
else
    echo "📝 Creating new Claude hooks configuration..."
    
    # 新しいsettings.jsonを作成（新フォーマット）
    cat > "$SETTINGS_FILE" <<EOF
{
  "hooks": {
    "Stop": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "\$HOME/.claude/scripts/discord-notify.sh"
      }]
    }],
    "Notification": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "\$HOME/.claude/scripts/discord-notify.sh"
      }]
    }]
  }
}
EOF
    echo "✅ Claude hooks configured successfully!"
fi

echo
echo "🧪 Test the notification by running:"
echo "echo '{\"event\":\"Stop\"}' | $SCRIPT_PATH"
echo
read -p "Do you want to test the notification now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📤 Sending test notification..."
    if echo '{"event":"Stop"}' | "$SCRIPT_PATH"; then
        echo "✅ Test notification sent successfully!"
    else
        echo "❌ Test notification failed!"
    fi
    echo
    echo "📢 Sending custom notification test..."
    if echo '{"event":"Notification","message":"Discord通知セットアップ完了テスト"}' | "$SCRIPT_PATH"; then
        echo "✅ Custom test notification sent successfully!"
    else
        echo "❌ Custom test notification failed!"
    fi
else
    echo "⏭️  Skipping notification test"
fi
echo
echo "The notifications will be sent automatically when Claude Code stops or sends notifications."