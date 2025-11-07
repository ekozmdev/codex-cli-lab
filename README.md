# codex-cli-lab

Codex CLIを使うためのメモ集。

## リポジトリ

- GitHub: https://github.com/openai/codex

## OpenAI 公式サイト（Codex/CLI）

- Codex 製品ページ: https://openai.com/codex
- Codex CLI ドキュメント: https://developers.openai.com/codex/cli
- GPT-5 for Coding: https://cdn.openai.com/API/docs/gpt-5-for-coding-cheatsheet.pdf

## Codex CLIの現状

- 2023年3月にCodex APIは提供終了が告知され、Codex CLIも同様に積極的な開発・サポートが行われていない。
- 現在のOpenAI公式ドキュメントでは、コード生成用途でもGPT-4/GPT-4 Turbo/GPT-3.5 Turboなどの汎用モデルを利用することが推奨されている。
- GitHub Copilotをはじめとする主要な統合開発環境向けのアシスタントも、CodexからGPT-4系モデルへ移行している。

## 代替手段

1. **OpenAI API / CLIの最新版を利用する**
   - `openai` CLIまたは最新のOpenAI SDKを使用し、`gpt-4o-mini`などのモデルに対してコード生成リクエストを送る。
   - 既存のCodex CLIスクリプトは、エンドポイントやモデル名を置き換えることで再利用できる場合がある。
2. **GitHub Copilotの最新リリースを活用する**
   - Visual Studio CodeやJetBrains製品に組み込み、GPT-4/GPT-4oベースの補完を受ける。
3. **サードパーティCLIの検討**
   - communityベースでメンテされているGPT-4/GPT-3.5対応のCLIツールを利用し、Codex CLIに近い操作感を再現する。

## 参考タスク

- Codex CLI関連のサンプルやスクリプトを利用する際は、最新のOpenAI API仕様に合わせてエンドポイントやパラメータを更新する。
- 変更したスクリプトについては、READMEやコメントに移行手順と注意点を追記しておく。
- すべての変更内容について、コード・ドキュメントともにセルフレビューを行い、手順の抜けや記載漏れがないか確認する。

