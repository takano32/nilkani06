# エージェント共通ルール

## セッションログの保存

作業セッションが終わるたびに、以下の2形式で `.agents/logs/` にログを保存すること。

### ファイル名

```
.agents/logs/YYYY-MM-DD_HH-MM-SS.md
.agents/logs/YYYY-MM-DD_HH-MM-SS.json
```

日時はセッション開始時刻（またはログ作成時刻）を使う。

### Markdown ファイルの構成（人間向け）

```markdown
# エージェントセッション — YYYY-MM-DD HH:MM:SS

## 概要
（このセッションで何をしたかを1〜3文で）

## 変更ファイル一覧
| ファイル | 操作 | 内容 |
...

## 会話ログ
（ユーザーの発言とエージェントの行動を交互に記録）

## 技術メモ
（設計上の判断・制約・注意点など）
```

### JSON ファイルの構成（ツール向け）

```json
{
  "session": { "date": "...", "time": "...", "agent": "..." },
  "summary": "...",
  "files_changed": [{ "path": "...", "op": "created|updated|deleted", "note": "..." }],
  "conversation": [{ "role": "user|assistant", "content": "..." }]
}
```

### 保存タイミング

- セッション終了時（ユーザーから明示的に終了・完了の合図があったとき）
- または「ログを保存して」と言われたとき
- `.agents/logs/` が存在しない場合は作成してから保存する

## スキル定義

`.agents/skills/SKILL.md` にこのプロジェクト固有のスキル・作業パターンを記録する。
新しい知見が生まれたらそのセッションのうちに追記すること。
