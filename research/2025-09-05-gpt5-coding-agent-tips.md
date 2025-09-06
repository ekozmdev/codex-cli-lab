# GPT-5をコーディングエージェントとして活用するための実践ノウハウ集

更新日: 2025-09-05

要旨: 本レポートは、OpenAIのGPT-5をコーディングエージェント（ソフトウェア開発支援の自律エージェント）として利用する際の実践的なノウハウと設計指針を、OpenAI公式情報と一次資料を中心にコンパクトに整理したものである。モデル選定、エージェント設計、ツール連携、プロンプト設計、評価・観測、セキュリティ/コンプライアンス、運用の観点から、現場で役立つチェックリストとアンチパターンを提示する。主要な記述には文献番号による引用を付与した。

---

## 1. 背景と位置づけ（なぜGPT-5でエージェントか）

- GPT-5は、推論能力・ツール使用・長時間タスク処理の面で強化され、開発者向けにはエージェント構築に直結する機能（最小限の推論、冗長度制御、並列ツール実行、カスタムツール統合など）が提供されている[1][2]。特にResponses APIの拡充により、コード実行・Web検索・ファイル検索・コンピュータ操作などのビルトインツールをAPIから統一的に扱える[4]。
- GPT-5はコーディング系ベンチマークにおいて高い性能を示し（例: SWE-bench系指標）、現実的なソフトウェア修正タスクに有効と報告されている[2][7]。エージェントとして運用する場合は、ベンチマーク値だけでなく、ツール呼び出しの信頼性や再現性（τ-Benchなど）も重視する[8]。

## 2. モデル選定とAPIパラメータの考え方

- モデル選定: コーディングでの主力は`gpt-5`（高性能）と、その軽量版（例: mini/中間サイズ）を使い分けるのが一般的[2]。高速応答が必要な補助タスクや前処理は軽量版、設計やデバッグ計画・複雑な修正は`gpt-5`本体に寄せる。
- 推論・冗長度の調整: 「最小限の推論（minimal reasoning）」「verbosity（冗長度）」などの制御が導入され、コスト/遅延と品質の最適点を探りやすい[2]。大量の小さな編集ループでは推論を抑制、難所のデバッグ時は高める、といったダイナミック制御が有効。
- Structured Outputs: JSON Schema等で出力構造を固定することで、パッチ生成やタスク状態管理の堅牢性が向上する[6]。
- 並列ツール実行とカスタムツール: エージェントの待ち時間を短縮し、観測・実行・要約を同時進行で進められる。外部システムを「カスタムツール」として統合する設計を前提にする[2][5]。

## 3. エージェント設計パターン（単体→多エージェント）

- 単体エージェント基本ループ: 「理解→計画→ツール実行→検証→要約→次アクション」のReAct/Plan-Act系ループを採用。Responses APIのビルトインツール（Code Interpreter、Web検索、ファイル検索、コンピュータ操作）で多くの開発作業を内製化できる[4]。
- 多エージェント連携: 設計（Architect）/実装（Coder）/テスト（Tester）/レビュア（Reviewer）の専門エージェントを役割分担し、Agents SDKでハンドオフやガードレール、トレーシングを行う[5][9]。
- セッション/トレーシング: トレースから「どのプロンプト/ツールが成果に寄与したか」を計測。再現性の担保（seed管理・ツールI/Oのログ化）と回帰検知に役立つ[5]。

## 4. ツール連携（Responses APIのビルトイン＋MCP）

- Code Interpreter: テスト実行、ローカル解析、データ整形、静的解析の下準備などに活用[4]。
- Web検索・ファイル検索: ランタイムの依存解決や既存コードベース理解に有効。検索結果→要約→根拠リンク（引用）までを一連タスクとして扱う[4]。
- コンピュータ操作（Computer Use）: GUI操作やIDE内の一貫タスクを自動化（要ガードレール）。人間の承認をインタラクティブに組み込む[4]。
- MCP（Model Context Protocol）/リモートツール: 社内APIや知識ベースを「外部ツール」として統合。ツール境界ごとに権限/監査を分離[4][5]。

## 5. プロンプト設計・運用Tips（コーディング特化）

1) 役割とゴールの固定化: 「対象レポジトリの意図」「変更の最小性」「副作用の回避」「テスト基準」を上位システムプロンプトで明示。

2) 計画の外化: ツール実行前に簡潔なプレアンブル（次に何をするか）と、チェックリスト（完了条件）を生成させる。長タスクはマイルストーンとタイムアウト条件を定義[2][5]。

3) 出力拘束: Structured Outputsで`{action, rationale, patch, test_plan}`等のスキーマを設ける。パッチは「差分（unified diff）」を基本形式にし、生成→適用→失敗時のロールバック手順まで含める[6]。

4) 知識の分離: 社内ポリシー・ドメイン知識はRAG/MCPでツール化し、プロンプト内には方針と参照だけを置く。更新容易性と漏洩リスク低減に寄与[5]。

5) 失敗前提の設計: JSON破損・ツール呼び出し失敗・テストフレーク等を前提に、自己修復リトライ（例: 形式検証→自動再生成→縮退運転）を標準化[2][6][8]。

## 6. レポジトリ規模のコーディング手順（実務チェックリスト）

- スコープ定義: 目的、成功基準、非目標、影響範囲（コード/ドキュメント/CI）を最初に固定。
- 収集: 変更対象のソース、関連テスト、設定/スクリプトをファイル検索で収集し、要点を要約。
- 計画: 小さなPR単位に分割。各PRは「仕様→差分→テスト→検証ログ→ロールバック」の最小セットを持つ。
- 生成: Structured Outputsで`diff`と`test_plan`を強制。パッチ適用前に静的検証（lint/型/フォーマッタ）を走らせ、失敗時は自己修復。
- 実行: Code Interpreterでユニットテスト→主要経路の手動確認（Computer Use併用）。
- 記録: トレースURL・重要判断の理由・バージョン/ツールのハッシュを残し、再実行性を担保[5]。

## 7. 観測・評価（SWE-bench/τ-Benchの併用）

- タスク完了率と品質: SWE-bench Verified等の実課題ベンチマークで、パッチ適用→テスト合格の最終成績を測る[2][7]。
- ツール信頼性: τ-Benchを参考に「ツール呼び出し成功率」「JSON妥当性」「再実行一致率」をモニタリング[8]。
- 運用可観測性: Agents SDK/プラットフォームのトレーシングを常時オン。要約（reasoning summaries）で人間レビュアの監査コストを削減[4][5]。

## 8. セキュリティ・コンプライアンス

- ガードレール: 入出力フィルタ、機能トグル（書込み系ツールの権限昇格は要承認）、監査ログの保全を標準装備[5]。
- 機密性と最小権限: 推論内容の暗号化や、最小権限でのツール実行、データ保持ポリシーの遵守[4][5]。
- 安全完了（safe completion）: 危険アクションや誤実行を検知したら、人間にハンドオフする分岐をテンプレート化[1][2]。

## 9. 実装テンプレ（概念例）

> 注意: 実際のパラメータ名・API仕様はプラットフォーム公式ドキュメントを参照してください（参考文献[4][プラットフォームDocs]）。以下は設計の要点を示す概念例です。

### Node.js（概念例）

```ts
import OpenAI from "openai";
const client = new OpenAI();

const response = await client.responses.create({
  model: "gpt-5",
  input: [
    { role: "system", content: "You are a cautious coding agent. Generate unified diffs only." },
    { role: "user", content: "Fix the failing test in parser and explain plan briefly." }
  ],
  // 例: 推論や冗長度、ツール利用の制御
  // reasoning: { effort: "low" },
  // verbosity: "medium",
  tools: [
    { type: "code_interpreter" },
    { type: "web_search" },
    { type: "file_search" }
  ],
  // structured outputs で diff/test_plan を強制するイメージ
  // response_format: { type: "json_schema", schema: DiffSchema }
});
```

### Python（概念例）

```python
from openai import OpenAI

client = OpenAI()

resp = client.responses.create(
    model="gpt-5",
    input=[
        {"role": "system", "content": "You write minimal, reversible patches with tests."},
        {"role": "user", "content": "Add input validation to /api/users and unit tests."}
    ],
    # reasoning={"effort": "high"},
    # verbosity="low",
    tools=[{"type": "code_interpreter"}, {"type": "file_search"}],
    # response_format={"type": "json_schema", "schema": PatchSchema},
)
```

## 10. よくある落とし穴と回避策

- JSON構造崩れ: スキーマ強制と自己修復（バリデーション→再生成→縮退出力）。
- ツール失敗の見落とし: 失敗時に必ず観測イベントを出し、エージェントが自覚して計画を更新するルールを設ける[4][8]。
- 大規模差分の暴走: PR分割、変更の最小性、部分適用と早期テストを徹底。
- 知識の陳腐化: 外部知識はRAG/MCP化し、更新サイクルを可視化。

---

## 11. Codex CLI前提の運用ポイント（本レポートの想定環境）

- プレアンブル運用: 各ツール呼び出し前に短い「次に何をするか」を明示。関連アクションはひとまとめにし、8–12語程度で簡潔に[2]。
- 進行管理: `update_plan`で非自明な工程のみをTODO化。常に1件だけ`in_progress`にしてレビュー/介入ポイントを明確化。
- 差分適用: 変更は`apply_patch`のunified diffで最小差分を原則化。ファイル移動は`Move to`、不要フォルダは安全に削除（空ディレクトリのみ）。
- 検証方針: 変更箇所に最も近い単体検証→周辺→全体の順で漸進的に実行。テストが存在する場合は最優先で回す。
- Web検索の遵守: 情報鮮度が問われる場合は`web.run`で一次情報（OpenAI公式・論文・ベンチ原典）を確認し、本文に番号付き引用を付す[4][6]。
- ツール権限: 書込みや破壊的操作は承認フロー（例: on-request）で昇格。ネットワーク利用や大量削除は事前に意図を短く共有。
- 出力拘束: 重要アクションはStructured Outputs（JSON Schema）で型拘束し、`{plan, patch, test_plan, risks}`等の構造化を推奨[6]。
- トレーシング: 主要判断とツールI/Oはログ化し、失敗時の自己修復（再生成・縮退）を標準ルーチン化[5][9]。

### 11.1 推奨システムプロンプト（Codex CLI向けテンプレート）

以下は本レポートで推奨する、Codex CLI前提のシステムプロンプト最小セット（必要に応じて社内ルールを追加）。Codexは「ツール前プレアンブル」を良質に出すよう学習されているため、短い進捗共有を明示的に要求するのが有効[10]。

```
You are a coding agent running in the Codex CLI.

Goals
- Deliver correct, minimal, and reviewable changes.
- Keep user informed with brief, helpful preambles.

Operating Rules
- Before any tool call, emit a one-sentence preamble (8–12 words) that states your next action and why.
- Maintain a concise plan via `update_plan`; track only non-trivial tasks; keep exactly one `in_progress`.
- Apply edits with `apply_patch` using minimal, surgical diffs. Do not over-edit unrelated code.
- When presenting file references, include clickable paths with 1-based line numbers (e.g., `src/app.ts:42`).
- Use Conventional Commits for proposed commit messages (e.g., `feat: add X`, `fix: handle Y`).
- Respect approvals: network access or work outside the repo requires explicit approval; avoid destructive actions unless asked.
- Prefer medium reasoning; raise for complex debugging; lower for batch edits.
- When information freshness matters, browse and cite authoritative sources. Prefer OpenAI official docs and primary sources.

Preambles & Summaries
- Start with a preamble; narrate group actions together; keep it terse and friendly.
- After large changes, summarize what changed and why; separate outcome from next steps.

Editing Guardrails
- Follow the project’s existing style and architecture; avoid large refactors unless requested.
- Add tests close to changed code when feasible; run the narrowest checks first.
- If requirements are ambiguous, make the most reasonable assumption, proceed, and document assumptions in the summary.
```

参考: Codex CLIの承認モードとモデル推奨（GPT‑5、高/中/低のreasoning設定）、およびツール前プレアンブルの考え方は公式ドキュメント/ガイドに整備されている[11][12][10]。

### 11.2 AGENTS.md テンプレート（最小構成・例）

AGENTS.mdは、コーディングエージェント向けの「READMEに相当する作業要領ファイル」。CodexはAGENTS.mdを通じてプロジェクト固有の前提や検証手順を参照できるため、リポジトリ直下に設置することを推奨[12][13]。

```
# AGENTS.md (sample, minimal)

## Project context
- Tech stack: <lang/framework>
- Targets: <runtimes/browsers>
- Non-goals: <out-of-scope>

## Coding rules
- Style: follow existing patterns; avoid large refactors.
- Commits: Conventional Commits; Japanese messages allowed.
- File references: include `path:line` form.

## Dev environment tips
- Install: <package mgr / versions>
- Useful scripts: <e.g., pnpm test -w, make fmt>
- Run subset tests: <command>

## Verification
- Repro steps: <how to run, inputs>
- Linters/type checks: <commands>
- Accept criteria: <bullet list>

## Risk & approvals
- Dangerous actions (rm -rf, db migrate, secrets): require explicit approval.
- Network access: prohibited unless approved.
```

実プロジェクトでは、上記に「ディレクトリ構造」「依存の固定方針」「CIで落ちやすい規約」「禁止コマンド」「レビュー観点チェックリスト」等を追記すると効果的[13]。

### 11.3 承認フロー（Codex CLIのApproval modes）

- Auto（既定）: 作業ディレクトリ内での読み書き・コマンド実行は自動許可。作業ディレクトリ外やネットワークは都度承認が必要[11]。
- Read Only: 参照中心で計画やレビュー前の下調べに有効。書込み/実行は承認ベース[11]。
- Full Access: ネットワーク含む広範な操作を承認なしで実行。慎重に使用[11]。

運用の勘所: 日常はAutoで十分。未知の外部アクセスや破壊的操作が絡む場合は、必ず事前にプレアンブルで意図を伝えた上で承認を取る。CI/非対話用途では`codex exec`と最小権限の組合せを検討[11]。

### 11.4 GPT‑5 Prompting Guideの要点（コーディングエージェント適用）

- Agentic eagernessの調整: 迅速化したいときは`reasoning_effort`を下げ、探索深度やツール呼出し予算を明示。自律性を上げたいときは`reasoning_effort`を上げ、粘り強く完遂する<persistence>指針を与える[10]。
- ツール前プレアンブル: 方針→計画→進捗→まとめの短い更新で体験が向上。どの程度説明するかはプロンプトで調整可能[10]。
- Reasoning再利用: Responses APIで`previous_response_id`を渡すと推論文脈を再利用でき、τ‑Benchのような評価でも改善が確認された[10]。
- コーディング実務: フロントエンドでは推奨スタック（Next.js/TypeScript、Tailwind、shadcn/ui等）や編集規則（guiding_principles, code_editing_rules）を事前提示すると質が上がる。コードは読みやすさ重視、ステータス出力は簡潔に[10]。

### 11.5 実務での最小サンプル（このレポートの流儀）

1) システムプロンプト: 本節11.1のテンプレートをベースに、必要なら「社内禁止事項」「優先度」「テスト必須範囲」を追記。

2) AGENTS.md: 上の最小例に、各プロジェクトの検証手順（再現、テスト、リンタ、期待値）と危険操作の扱いを具体化。

3) 依頼時の最小入力例（Codex CLI）:
```
目的: 既存の`x`ユースケースで落ちるテストを修復する
制約: 変更は最小、関連ファイル以外は触れない
検証: `pnpm test -w --filter pkg-x` がgreenになること
注意: 外部ネットワークアクセスは要承認。破壊的操作は禁止
補足: 参考イシュー #123 の再現手順に従う
```

4) 提案コミットメッセージ例（Conventional Commits）:
```
fix(pkg-x): flakyな日付処理をUTC固定で安定化

理由: ローカルタイムゾーン依存で不安定化していたため
影響: 既存API互換、追加テストで担保
```

---

## 参考文献（一次情報優先）

[1] OpenAI, “Introducing GPT‑5,” Aug 7, 2025. https://openai.com/index/introducing-gpt-5/

[2] OpenAI, “Introducing GPT‑5 for developers,” Aug 7, 2025. https://openai.com/index/introducing-gpt-5-for-developers/

[3] OpenAI, “GPT‑5 is here” (Product page). https://openai.com/gpt-5

[4] OpenAI, “New tools and features in the Responses API,” May 21, 2025. https://openai.com/index/new-tools-and-features-in-the-responses-api/

[5] OpenAI, “New tools for building agents,” Mar 11, 2025. https://openai.com/index/new-tools-for-building-agents/

[6] OpenAI, “Introducing Structured Outputs in the API,” Aug 6, 2024. https://openai.com/index/introducing-structured-outputs-in-the-api/

[7] Princeton NLP, “SWE-bench,” GitHub repository. https://github.com/princeton-nlp/SWE-bench

[8] Yao, Shinn, Razavi, Narasimhan, “τ‑bench: A Benchmark for Tool‑Agent‑User Interaction in Real‑World Domains,” arXiv:2406.12045, 2024. https://arxiv.org/abs/2406.12045

[9] OpenAI Developers, “Building agents” (Docs track). https://developers.openai.com/tracks/building-agents/

[10] OpenAI Cookbook, “GPT‑5 prompting guide,” Aug 7, 2025. https://cookbook.openai.com/examples/gpt-5/gpt-5_prompting_guide

[11] OpenAI Developers, “Codex CLI,” accessed Sep 6, 2025. https://developers.openai.com/codex/cli

[12] GitHub (OpenAI), “openai/codex – README/Docs,” accessed Sep 6, 2025. https://github.com/openai/codex

[13] GitHub (OpenAI), “openai/agents.md – AGENTS.md,” accessed Sep 6, 2025. https://github.com/openai/agents.md

（リンクは2025-09-06時点で存在確認済み）
