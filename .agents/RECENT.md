# プロジェクト現状 — 2026-05-29 更新

## 現在の構成

- **プラットフォーム**: Discord (Gateway / discord.js v14)
- **LLM**: Groq API (llama-3.3-70b-versatile)、openai パッケージの baseURL 差し替えで利用
- **主要ファイル**:
  - `bot.js` — Discord メッセージ受信 → Groq API 呼び出し → reply
  - `boot.bash` — 無限再起動ループ + Discord Webhook 通知
- **環境変数**: `DISCORD_TOKEN` / `DISCORD_WEBHOOK_URL` / `GROQ_API_KEY` / `GROQ_MODEL` / `SYSTEM_PROMPT` / `MAX_HISTORY`
- **セッション保存**: `sessions/YYYY-MM-DD_HH-MM-SS.json`（.gitignore 済み）
- **履歴復元**: 起動時に過去 sessions/*.json を読み込み、チャンネルごとに直近 MAX_HISTORY 件を Groq に渡す
- **エージェント文脈**: セッション終了時に `.agents/RECENT.md` を上書き → 次セッション開始時に AGENTS.md 経由で自動ロード

## 直近の変更

- Slack Bot → Discord Bot へ全面移行（bot.js・boot.bash・package.json・CLAUDE.md）
- `loadPastSessions()` を実装し、再起動をまたいだ会話継続を実現（MAX_HISTORY で上限制御）
- `.agents/RECENT.md` を導入し AGENTS.md から `@` インクルード → 次セッションに文脈を自動引き継ぎ
- SKILL.md・AGENTS.md のセッション終了手順を RECENT.md 上書きも含む形に更新

## 次のセッションへの申し送り

特になし。
