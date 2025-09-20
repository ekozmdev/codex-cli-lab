#!/bin/zsh

set -euo pipefail

SOURCE_DIR="$HOME/.codex"
TARGET_DIR="my-config/.codex"

mkdir -p "$TARGET_DIR"

cp $SOURCE_DIR/AGENTS.md $TARGET_DIR/AGENTS.md
cp $SOURCE_DIR/config.toml $TARGET_DIR/config.toml
cp -r $SOURCE_DIR/prompts/* $TARGET_DIR/prompts/