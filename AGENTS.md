# AGENTS.md

- このファイルは、このリポジトリ運用用の手順書です。
- `.codex/AGENTS.md`はユーザーレベル設定として同期する実体のため、このファイルとは別物です。

## 管理対象

- `.codex/AGENTS.md`
- `.codex/config.toml`
- `.codex/rules`

## Config Sync Workflow

### 1. `.draft` にスナップショットを作成する

```sh
DATE="$(date +%F)"
mkdir -p .draft
cp -f ~/.codex/AGENTS.md ".draft/${DATE}-AGENTS.md"
cp -f ~/.codex/config.toml ".draft/${DATE}-config.toml"
rm -rf ".draft/${DATE}-rules"
cp -R ~/.codex/rules ".draft/${DATE}-rules"
```

### 2. `.draft` とリポジトリ管理設定の差分を確認する

```sh
DATE="YYYY-MM-DD"
diff -u ".draft/${DATE}-AGENTS.md" .codex/AGENTS.md
diff -u ".draft/${DATE}-config.toml" .codex/config.toml
diff -ru ".draft/${DATE}-rules" .codex/rules
```

### 3. 変更した内容をユーザーに説明し、相談しながらリポジトリ側へ反映する

1. `AGENTS.md`（`.codex/AGENTS.md`）で変更した内容を説明する。
   採用する差分がある場合は、リポジトリ側の `.codex/AGENTS.md` を修正する。
2. `config.toml`（`.codex/config.toml`）で変更した内容を説明する。
   採用する差分がある場合は、リポジトリ側の `.codex/config.toml` を修正する。
3. `rules`（`.codex/rules`）で変更した内容を説明する。
   `default.rules` の各ルールを 1 件ずつ説明し、要る・要らないをユーザーと判断する。
   要る場合は、既存 `*.rules` に追記するか新規 `*.rules` を作成するかをユーザーと相談して決めて移す。
   要らない場合は、ユーザー合意のうえで削除する。
   このステップの完了条件は `.codex/rules/default.rules` を空にすること。
4. ユーザーと合意した内容だけを反映し、未合意の変更は反映しない。

### 4. 管理対象のみを `~/.codex` へ同期する

```sh
mkdir -p "$HOME/.codex"
cp -f .codex/AGENTS.md "$HOME/.codex/AGENTS.md"
cp -f .codex/config.toml "$HOME/.codex/config.toml"
mkdir -p "$HOME/.codex/rules"
rsync -a --delete .codex/rules/ "$HOME/.codex/rules/"
```

### 5. `.draft` の中身を削除する（`.gitkeep` は残す）

```sh
DATE="YYYY-MM-DD"
rm -f ".draft/${DATE}-AGENTS.md"
rm -f ".draft/${DATE}-config.toml"
rm -rf ".draft/${DATE}-rules"
```

### 6. 変更内容をレビューしてまとめを報告する

- `AGENTS.md`、`.codex/AGENTS.md`、`.codex/config.toml`、`.codex/rules`について、何をどう変更したかをユーザーに説明する。

### 7. 変更をコミットしてプッシュする

- `.draft` はディレクトリ本体（`.gitkeep`）のみをコミットし、退避した中身はコミットしない。
