# プロジェクト現状 — 2026-05-29 更新

## 現在の構成

- **プラットフォーム**: Discord (Gateway / discord.js v14)
- **LLM**: Groq API (llama-3.3-70b-versatile)、openai パッケージの baseURL 差し替えで利用
- **主要ファイル**:
  - `bot.js` — Discord メッセージ受信 → Groq API 呼び出し → reply
  - `boot.bash` — 無限再起動ループ + Discord Webhook 通知
- **環境変数**: `DISCORD_TOKEN` / `DISCORD_WEBHOOK_URL` / `GROQ_API_KEY` / `GROQ_MODEL` / `SYSTEM_PROMPT` / `MAX_HISTORY`
- **セッション保存**: `sessions/YYYY-MM-DD_HH-MM-SS.json`（.gitignore 済み）
- **デプロイ先**: GCP e2-micro / プロジェクト: takano32 / ゾーン: us-central1-a / Debian 13 / 外部IP: 136.119.31.175
- **サービス管理**: systemd (`nilkani06.service`, `Restart=always`, `EnvironmentFile=~/nilkani06/.env`)

## 直近の変更

- README.md の Slack 記述を Discord に全面修正
- GCP e2-micro インスタンス作成・Node.js 22 インストール・リポジトリクローン・systemd 登録完了

## 次のセッションへの申し送り

特になし。本番稼働中。
