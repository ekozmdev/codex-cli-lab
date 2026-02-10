# AGENTS.md

このファイルは、このリポジトリ運用用の手順書。
`.codex/AGENTS.md`（ユーザーレベル設定として同期する実体）とは分けて管理する。

## 管理対象
- `.codex/AGENTS.md`
- `.codex/config.toml`
- `.codex/rules`

## Config Sync Workflow
### 1. `.draft` にスナップショットを作成する
```sh
TODAY="$(date +%F)"
mkdir -p .draft
cp -f ~/.codex/AGENTS.md ".draft/${TODAY}-AGENTS.md"
cp -f ~/.codex/config.toml ".draft/${TODAY}-config.toml"
rm -rf ".draft/${TODAY}-rules"
cp -R ~/.codex/rules ".draft/${TODAY}-rules"
```

### 2. 日付付きスナップショットとの差分を確認する
```sh
SNAPSHOT_DATE="YYYY-MM-DD"
diff -u .codex/AGENTS.md ".draft/${SNAPSHOT_DATE}-AGENTS.md" || true
diff -u .codex/config.toml ".draft/${SNAPSHOT_DATE}-config.toml" || true
diff -ru .codex/rules ".draft/${SNAPSHOT_DATE}-rules" || true
```

### 3. `default.rules` の追加分を整理する
```sh
diff -u ".draft/${SNAPSHOT_DATE}-rules/default.rules" ".codex/rules/default.rules" || true
```

- 追加されているルールがある場合、`default.rules` に残すか、別の `*.rules` に分割するかを必ずユーザーに確認する。
- 既存ルールを削除候補にする場合も、削除してよいかを必ずユーザーに確認する。
- ユーザー確認なしで `default.rules` から別ファイルへ移動・削除しない。
- 分割する場合は、用途が分かるファイル名（例: `python.rules` `local.rules`）に整理する。

### 4. 差分を評価・マージ・整理してリポジトリ側を更新する

### 5. 管理対象のみを `~/.codex` へ同期する
```sh
mkdir -p "$HOME/.codex"
cp -f .codex/AGENTS.md "$HOME/.codex/AGENTS.md"
cp -f .codex/config.toml "$HOME/.codex/config.toml"
mkdir -p "$HOME/.codex/rules"
rsync -a --delete .codex/rules/ "$HOME/.codex/rules/"
```

### 6. `.draft` の中身を削除する（`.gitkeep` は残す）
```sh
find .draft -mindepth 1 -maxdepth 1 ! -name '.gitkeep' -exec rm -rf {} +
```

### 7. 作成・編集した内容をレビューする
```sh
git status --short
git diff -- AGENTS.md README.md .codex/AGENTS.md
```

- `.draft` はディレクトリ本体（`.gitkeep`）のみをコミットし、退避した中身はコミットしない。
