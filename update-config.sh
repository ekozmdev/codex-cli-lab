#!/bin/zsh

set -euo pipefail

CODEX_SOURCE_DIR="$HOME/.codex"
CODEX_TARGET_DIR=".codex"
AGENTS_SOURCE_DIR="$HOME/.agents"
AGENTS_TARGET_DIR=".agents"

# 受け入れ先ディレクトリを用意
mkdir -p "$CODEX_TARGET_DIR"
mkdir -p "$AGENTS_TARGET_DIR"

# 明示的に対象を列挙して同期（削除も反映）
CODEX_FILE_ITEMS=(
  "AGENTS.md"
  "config.toml"
)

CODEX_DIR_ITEMS=(
  "prompts"
  "rules"
)

# ~/.codex 側のファイルを同期
for item in "${CODEX_FILE_ITEMS[@]}"; do
  src="$CODEX_SOURCE_DIR/$item"
  dest="$CODEX_TARGET_DIR/$item"
  if [[ -f "$src" ]]; then
    rsync -a "$src" "$dest"
  else
    rm -f "$dest"
  fi
done

# ~/.codex 側のディレクトリを同期
for item in "${CODEX_DIR_ITEMS[@]}"; do
  src="$CODEX_SOURCE_DIR/$item"
  dest="$CODEX_TARGET_DIR/$item"
  if [[ -d "$src" ]]; then
    rsync -a --delete "$src/" "$dest/"
  else
    rm -rf "$dest"
  fi
done

# ~/.agents 側の skills を同期
AGENTS_DIR_ITEMS=(
  "skills"
)

for item in "${AGENTS_DIR_ITEMS[@]}"; do
  src="$AGENTS_SOURCE_DIR/$item"
  dest="$AGENTS_TARGET_DIR/$item"
  if [[ -d "$src" ]]; then
    rsync -a --delete "$src/" "$dest/"
  else
    rm -rf "$dest"
  fi
done

# 更新時刻を記録
date "+%Y-%m-%d %H:%M:%S" > "./LAST_UPDATE"
