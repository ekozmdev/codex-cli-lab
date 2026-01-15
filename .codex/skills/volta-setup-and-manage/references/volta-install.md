# Volta のインストール / アンインストール

## 公式ドキュメント
- https://docs.volta.sh/guide/getting-started
- https://www.voltajs.com/guide/getting-started
- https://docs.volta.sh/advanced/uninstall

## macOS / Linux
- `curl https://get.volta.sh | bash`
- セットアップをスキップした場合は `VOLTA_HOME` を `$HOME/.volta` に設定し、`$VOLTA_HOME/bin` を PATH の先頭に追加する。
- 変更が反映されない場合はシェルを再起動する。

## Windows
- `winget install Volta.Volta`
- WSL は macOS / Linux と同じ方法でインストールする。

## 確認
- `volta --version` または `volta -v` で確認する。

## Volta 自体のアンインストール
- macOS / Linux: `~/.volta` を削除し、シェル設定から VOLTA_HOME / PATH の追記を削除する。
- Windows: アプリの削除から Volta をアンインストールする。
