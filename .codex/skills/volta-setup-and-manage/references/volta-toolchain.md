# Volta のツールチェーン管理

## 公式ドキュメント
- https://docs.volta.sh/reference/install
- https://docs.volta.sh/reference/pin
- https://docs.volta.sh/reference/list
- https://docs.volta.sh/reference/uninstall
- https://docs.volta.sh/reference/which
- https://docs.volta.sh/guide/understanding
- https://www.voltajs.com/reference/uninstall

## デフォルトのツールチェーンを設定する
- `volta install node` で最新の LTS をデフォルトにする。
- 特定バージョンを使う場合は `volta install node@<version>` を使う。
- パッケージマネージャは `volta install npm@<version>` / `volta install yarn@<version>` / `volta install pnpm@<version>` を使う。
- CLI を持つグローバルパッケージは `volta install typescript@<version>` のように入れる。

## プロジェクトに固定する
- プロジェクトルートで `volta pin node@<version>` / `volta pin npm@<version>` / `volta pin yarn@<version>` / `volta pin pnpm@<version>` を実行する。
- `volta pin` は `package.json` に `volta` セクションを追加・更新する。
- `volta pin` は Node とパッケージマネージャ専用。

## インストール済みの確認
- `volta list` でインストール済みを表示する。
- `volta list --default` でデフォルトのツールチェーンを確認する。
- `volta list --current` で現在の解決状況を確認する。

## アンインストール（ツール / パッケージ）
- `volta uninstall node` / `volta uninstall npm` / `volta uninstall yarn` / `volta uninstall pnpm` でデフォルトから外す。
- `volta uninstall <package>` で Volta 経由のグローバルパッケージを削除する。
- `volta uninstall` はデフォルトツールチェーンから外し、グローバルパッケージは削除されるが、pin されているバージョンのキャッシュは残る。
- キャッシュも削除したい場合は `~/.volta/tools/` を削除する（影響確認のうえで実施）。

## トラブルシューティング
- `volta which <tool>` で実際に解決されるバイナリを確認する。
- `volta list --current` で現在の解決状況を確認する。
