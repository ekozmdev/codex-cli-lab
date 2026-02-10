# my-codex-cli-settings

codex-cliの設定を保管するリポジトリ

- このリポジトリでは `skills` を管理しない
- このリポジトリでは `prompts` を管理しない
- 正として管理する対象は `.codex/AGENTS.md` `.codex/config.toml` `.codex/rules`

## 運用フロー

1. マシンの設定を `.draft` にコピー
   - `TODAY="$(date +%F)"`
   - `mkdir -p .draft`
   - `cp -f ~/.codex/AGENTS.md ".draft/${TODAY}-AGENTS.md"`
   - `cp -f ~/.codex/config.toml ".draft/${TODAY}-config.toml"`
   - `rm -rf ".draft/${TODAY}-rules"`
   - `cp -R ~/.codex/rules ".draft/${TODAY}-rules"`
2. リポジトリとの差分を確認
   - `SNAPSHOT_DATE="YYYY-MM-DD"`
   - `diff -u .codex/AGENTS.md ".draft/${SNAPSHOT_DATE}-AGENTS.md" || true`
   - `diff -u .codex/config.toml ".draft/${SNAPSHOT_DATE}-config.toml" || true`
   - `diff -ru .codex/rules ".draft/${SNAPSHOT_DATE}-rules" || true`
3. Codex で評価・マージ・整理（このリポジトリ側を更新）
4. 管理対象のみをマシンへ反映（上書き）
   - `mkdir -p "$HOME/.codex"`
   - `cp -f .codex/AGENTS.md "$HOME/.codex/AGENTS.md"`
   - `cp -f .codex/config.toml "$HOME/.codex/config.toml"`
   - `mkdir -p "$HOME/.codex/rules"`
   - `rsync -a --delete .codex/rules/ "$HOME/.codex/rules/"`
5. 作業完了後に `.draft` の中身を削除（`.gitkeep` は残す）
   - `find .draft -mindepth 1 -maxdepth 1 ! -name '.gitkeep' -exec rm -rf {} +`

`.draft` はフォルダのみを管理し、退避ファイルはコミットしない
