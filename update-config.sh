#!/bin/zsh

set -euo pipefail

SOURCE_DIR="$HOME/.codex"
TARGET_DIR=".codex"

# 受け入れ先ディレクトリを用意
mkdir -p "$TARGET_DIR"

# ファイルをコピー
cp "$SOURCE_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md"
cp "$SOURCE_DIR/config.toml" "$TARGET_DIR/config.toml"

# ディレクトリは存在する場合のみコピー
if [[ -d "$SOURCE_DIR/prompts" ]]; then
  cp -R "$SOURCE_DIR/prompts" "$TARGET_DIR/"
fi
if [[ -d "$SOURCE_DIR/skills" ]]; then
  cp -R "$SOURCE_DIR/skills" "$TARGET_DIR/"
fi
if [[ -d "$SOURCE_DIR/rules" ]]; then
  cp -R "$SOURCE_DIR/rules" "$TARGET_DIR/"
fi

# 更新時刻を記録
date "+%Y-%m-%d %H:%M:%S" > "$TARGET_DIR/LAST_UPDATE"
