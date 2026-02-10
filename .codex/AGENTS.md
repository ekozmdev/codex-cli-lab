# AGENTS.md

- These instructions are set at the user level.
- They apply to every codebase and every task.

## Communication
  - ユーザーとは日本語で会話してください.
  - Refrain from using emojis.

## Information Retrieval
  - Use English for all queries when using external information search tools whenever possible; Japanese is acceptable when necessary.
  - Use the model’s built-in web search tool when up-to-date information is required.

## Coding
  - Prioritize readability and ease of modification in code.
  - Do not directly create or edit files that are automatically generated or automatically updated by tools unless explicitly permitted.
    - Examples: package.json (Node.js), pyproject.toml (Python)

## Bug Troubleshooting
  - When the user reports an error, identify the cause first and report it.
  - Do not fix the code before reporting the cause.
  - For complex issues, add temporary debug logging to observe behavior, then remove it after resolution.
    - Mark debug code clearly with `TODO: Remove debug code before commit` comments.

## Task Management
  - Always include a task to review everything you create or edit (both code and documentation).

## Command Execution
  - Check the current working directory before running any command.

## Sub-agents
  - Spawn sub-agents when needed:
    - Large-scale file reading or exploration across many files
    - A second-perspective review is needed (design, risk, testing)

## Config Sync Workflow
  - このリポジトリを正として、`.codex/AGENTS.md` `.codex/config.toml` `.codex/rules` を管理する。
  - 同期作業の開始時は、次のコマンドで `~/.codex` の現行設定を `.draft` にコピーする。
    - `TODAY="$(date +%F)"`
    - `mkdir -p .draft`
    - `cp -f ~/.codex/AGENTS.md ".draft/${TODAY}-AGENTS.md"`
    - `cp -f ~/.codex/config.toml ".draft/${TODAY}-config.toml"`
    - `rm -rf ".draft/${TODAY}-rules"`
    - `cp -R ~/.codex/rules ".draft/${TODAY}-rules"`
  - `.draft` はディレクトリ本体（`.gitkeep`）のみをコミットし、退避した中身はコミットしない。
  - 差分確認は、対象日を固定して次のコマンドで行う。
    - `SNAPSHOT_DATE="YYYY-MM-DD"`
    - `diff -u .codex/AGENTS.md ".draft/${SNAPSHOT_DATE}-AGENTS.md" || true`
    - `diff -u .codex/config.toml ".draft/${SNAPSHOT_DATE}-config.toml" || true`
    - `diff -ru .codex/rules ".draft/${SNAPSHOT_DATE}-rules" || true`
  - 差分を Codex で評価・マージ・整理してリポジトリ側を更新する。
  - 最終的に次のコマンドで、管理対象のみを `~/.codex` へ上書き反映する。
    - `mkdir -p "$HOME/.codex"`
    - `cp -f .codex/AGENTS.md "$HOME/.codex/AGENTS.md"`
    - `cp -f .codex/config.toml "$HOME/.codex/config.toml"`
    - `mkdir -p "$HOME/.codex/rules"`
    - `rsync -a --delete .codex/rules/ "$HOME/.codex/rules/"`
  - 作業完了後は、`.draft` の中身を削除する（`.gitkeep` は残す）。
    - `find .draft -mindepth 1 -maxdepth 1 ! -name '.gitkeep' -exec rm -rf {} +`
