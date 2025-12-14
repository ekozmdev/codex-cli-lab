# Codex Skills機能のメモ

## 導入バージョン
- `docs/skills.md`が追加されたコミット `feat: experimental support for skills.md (#7412)` は、タグ `rust-v0.65.0` 以降に含まれており、技能（Skills）機能はv0.65.0で初めて導入された。対応タグには`rust-v0.65.0`以降の正式版・アルファ版が含まれる。

## 使い方の要点
- 状態: "Skills"は実験的・非安定機能であり、破壊的変更の可能性がある。
- スキル配置場所: v1では`~/.codex/skills/**/SKILL.md`配下に配置する（再帰的探索、隠しエントリとシンボリックリンクは無視、ファイル名は`SKILL.md`固定）。名前順→パス順で表示される。
- SKILL.mdのフォーマット: YAMLフロントマター＋本文。必須フィールドは`name`（非空・100文字以内・1行化）と`description`（非空・500文字以内・1行化）。追加キーは無視され、本文はコンテキストへは注入されない。
- 読み込みと表示: 起動時に1回ロードし、有効なスキルがあればランタイムの`AGENTS.md`後ろに`## Skills`セクションを追加し、`- <name>: <description> (file: /absolute/path/to/SKILL.md)`形式で列挙する。有効なスキルが無い場合はセクション自体が表示されない。
- バリデーション: YAML欠落・空欄・文字数超過など無効なスキルがあると、TUI起動時にブロッキングのモーダルで各パスとエラーが表示される（ログにも記録）。無効スキルは無視され、モーダルを閉じるか終了するまで進行しない。
- 作成手順例:
  1. `mkdir -p ~/.codex/skills/<skill-name>/`
  2. 以下のような`SKILL.md`を置く:
     ```
     ---
     name: your-skill-name
     description: what it does and when to use it (<=500 chars)
     ---

     # Optional body
     Add instructions, references, examples, or scripts (kept on disk).
     ```
  3. `name`/`description`の文字数と改行無しを守る。
  4. Codexを再起動するとスキルが読み込まれる。
