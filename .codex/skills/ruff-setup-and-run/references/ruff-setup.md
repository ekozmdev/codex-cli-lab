# ruffのセットアップ

## ruffのインストール

開発用の依存にruffをインストールします

```shell
# 例)
uv add --group dev ruff
```

## 設定

Python プロジェクトのルート（通常は `pyproject.toml` がある場所）に `ruff.toml` を配置します。設定内容は `python/ruff.toml` をコピーし、必要に応じて調整してください。

## プロジェクトのAGENTS.mdに追記

プロジェクトのAGENTS.mdにruffの使用方法がない場合は、以下の内容をAGENTS.mdに追記します

````markdown
## 3. 実行コマンド

### lint

```bash
# ソースを変更しない
ruff check .

# 変更内容を確認する
ruff check . --fix --diff

# ソースを変更する
ruff check . --fix
```

### format

```bash
# ソースを変更しない
ruff format . --check

# 変更内容を確認する
ruff format . --diff

# ソースを変更する
ruff format .
```

## 4. よく使う追加オプション

コミット前に一度実行してください。

### 未使用import / 未使用変数の削除

```bash
# 未使用 import と未使用変数を削除する
ruff check . --fix --unsafe-fixes --config "lint.fixable = ['F401', 'F841']"

# 未使用 import を削除する
ruff check . --fix --config "lint.fixable = ['F401']"

# 未使用変数を削除する（unsafe のため --unsafe-fixes が必要）
ruff check . --fix --unsafe-fixes --config "lint.fixable = ['F841']"
```

auto fix で治らないルール違反が出た場合は、`ruff rule F401` のようにしてルールの詳細を確認してから修正を開始してください。
````

ruffの実行方法はプロジェクトのパッケージ管理ツールに合わせて、適宜修正する。

## git管理対象外ディレクトリの設定

ruffを実行すると`.ruff_cache`ディレクトリが作成されるため、プロジェクトの`.gitignore`に`**/.ruff_cache/`を追記する
