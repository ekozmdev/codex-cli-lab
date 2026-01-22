#!/bin/zsh

set -euo pipefail

SOURCE_DIR="$HOME/.codex"
TARGET_DIR=".codex"

# 受け入れ先ディレクトリを用意
mkdir -p "$TARGET_DIR"

# 明示的に対象を列挙して同期（削除も反映）
FILE_ITEMS=(
  "AGENTS.md"
  "config.toml"
)

DIR_ITEMS=(
  "prompts"
  "skills"
  "rules"
)

for item in "${FILE_ITEMS[@]}"; do
  src="$SOURCE_DIR/$item"
  dest="$TARGET_DIR/$item"
  if [[ -f "$src" ]]; then
    rsync -a "$src" "$dest"
  else
    rm -f "$dest"
  fi
done

for item in "${DIR_ITEMS[@]}"; do
  src="$SOURCE_DIR/$item"
  dest="$TARGET_DIR/$item"
  if [[ -d "$src" ]]; then
    rsync -a --delete "$src/" "$dest/"
  else
    rm -rf "$dest"
  fi
done

# 更新時刻を記録
date "+%Y-%m-%d %H:%M:%S" > "./LAST_UPDATE"
