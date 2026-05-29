# プロジェクト現状 — 2026-05-29 更新

## 現在の構成

- **プラットフォーム**: Discord (Gateway / discord.js v14)
- **LLM**: OpenAI API (gpt-4o-mini)
- **主要ファイル**:
  - `bot.js` — Discord メッセージ受信 → OpenAI API 呼び出し → reply
  - `boot.bash` — 無限再起動ループ + Discord Webhook 通知
- **環境変数**: `DISCORD_TOKEN` / `DISCORD_WEBHOOK_URL` / `OPENAI_API_KEY` / `OPENAI_MODEL` / `SYSTEM_PROMPT` / `MAX_HISTORY`
- **セッション保存**: `sessions/YYYY-MM-DD_HH-MM-SS.json`（.gitignore 済み）
- **デプロイ先**: GCP e2-micro / プロジェクト: takano32 / ゾーン: us-central1-a / Debian 13 / 外部IP: 136.119.31.175
- **サービス管理**: systemd (`nilkani06.service`, `Restart=always`, `EnvironmentFile=~/nilkani06/.env`)

## 直近の変更

- Groq API (Llama) → OpenAI API (ChatGPT) へ移行
- 環境変数 `GROQ_API_KEY` → `OPENAI_API_KEY`、`GROQ_MODEL` → `OPENAI_MODEL` に変更
- `bot.js` から Groq の `baseURL` を削除
- `.env.example` / `CLAUDE.md` / `package.json` もすべて更新済み

## 次のセッションへの申し送り

- `.env` を `OPENAI_API_KEY=sk-...` に書き換えて `gcloud compute scp` で転送後、`sudo systemctl restart nilkani06` で反映すること
- `gpt-4o` に切り替えたい場合は `.env` に `OPENAI_MODEL=gpt-4o` を追加
