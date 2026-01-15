# export-error command

あなたはSWEエージェント／コーディングエージェントです。コーディング作業中に自身が遭遇した再発エラーについて、手元のコンテクスト（エディタ状態・実行ログ・バージョン管理差分など）を整理し、上位LLMに渡すための調査レポートを作成してください。

## 目的
- エラーの再現条件と影響範囲を手元データから明確化する。
- 既存の対応履歴と未解決の疑問点を洗い出す。
- 上位LLMが原因究明を続行できるだけの証拠と背景を提供する。

## 基本方針
1. 取得できた客観的情報のみを記述し、推測は避ける。推測が必要な場合は「未確認」と明示する。
2. 情報が不足している場合は、可能な限り自分の作業ログ・diff・再実行で補完する。取得できなければ「情報未取得」と記録する。
3. エラーメッセージ、該当コードスニペット、直前に実行したコマンドなど一次情報を必ず添付する。
4. レポートはMarkdownで出力し、機械処理しやすい構造を保つ。

## 収集観点（コンテクストから抽出）
- 発生タイミング: 初回発生日時、直近発生日時、発生頻度（例: 毎回／特定条件でのみ）
- 実行環境: リポジトリ名、ブランチ、コミットハッシュ、ランタイム／依存バージョン、OS
- トリガーとなった操作: 実行したコマンド、テスト、スクリプト、リクエストなど
- 該当コード: ファイルパス、行番号、関連する差分やコミット
- 期待動作と実際の挙動の差分
- エラーメッセージ／スタックトレース／ログ抜粋（行番号付きが望ましい）
- 影響範囲: ブロックされているタスク、影響を受ける機能やユーザー
- これまで試した対処（例: リトライ、依存更新、環境再構築）とその結果
- 関連する最近の変更（デプロイ、設定変更、マージ、環境変数更新など）
- 解決のために必要な追加調査・疑問点

## レポート出力フォーマット
以下のテンプレートに沿って Markdown でまとめる。空欄は `N/A` と記載する。
```
# Repeated Error Report

## Incident Summary
- Error Name / Key Message: 
- First Seen (YYYY-MM-DD): 
- Most Recent Occurrence (YYYY-MM-DD): 
- Frequency / Pattern: 
- Impact Summary: 

## Working Context Snapshot
- Repository / Branch: 
- Relevant Commit(s): 
- Active File(s) / Module(s): 
- Trigger Command or Action: 

## Environment
- Runtime & Version: 
- Operating System: 
- Dependencies / Integrations: 
- Configuration Flags / Env Vars: 

## Reproduction Steps
1. 
2. 
3. 

## Expected vs Actual
- Expected: 
- Actual: 

## Evidence
```text
<エラーメッセージ・スタックトレース・ログ・関連ファイルへのパスなどを必要なだけ貼り付ける>
```

## Attempts & Outcomes
- 

## Recent Changes
- 

## Open Questions / Next Needs
- 

## Confidence
- Self-assessed confidence level (High / Medium / Low): 
```

## 追加指示
- 重要な証跡（diff、ログ、コマンド結果）は改変せずに貼り付け、必要に応じて参照元パスを明示する。
- 機密情報が含まれる場合は適切にマスクする。
- 時系列情報は必ず ISO 形式の日付で記載する。
- レポート提出後、ギャップが残る場合は必要な追加データ取得（再実行・追加ログ収集など）を提案する。
---
