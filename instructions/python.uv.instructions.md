# uvに関するインストラクション

uvはpythonの仮想環境とパッケージ管理に使われます。

## バージョンを確認する

- uvがインストール済みであることを確認する
- uvのバージョンを確認する

```shell
uv --version
```

## プロジェクトを初期化する

- uvのプロジェクトを初期化する
- pythonのバージョンが指定がない場合は、ユーザーに確認する

```shell
# プロジェクトのディレクトリを作成する
mkdir {uvのプロジェクト名}
# プロジェクトのディレクトリに移動する
cd {uvのプロジェクト名}
# uv initコマンドで仮想環境を初期化する
# --pythonオプションでpythonのバージョンをマイナーバージョンまで指定する
uv init . --python 3.13
```

- {uvのプロジェクト名}に`pyproject.toml`が生成される
- `pyproject.toml`の以下の箇所を変更し、pythonのマイナーバージョンが固定されるようにする

```toml
# pythonのバージョンを`3.13`に固定する例
# 変更前
requires-python = ">=3.13"

# 変更後
# <3.14を追加することで、意図せずマイナーバージョンが上がることを防ぐ
requires-python = ">=3.13,<3.14"
```

- `pyproject.toml`に以下を追記して、パッケージのバージョン上限を固定する。

```toml
# メジャーバージョン固定により、破壊的変更を防ぐ
[tool.uv]
add-bounds = "major"
```

- 仮想環境を作成する

```shell
uv sync
```

- 仮想環境が作成されたことを確認する

```shell
uv run main.py
```

- 不要なサンプルコードを削除する

```shell
rm main.py
```

## ライブラリの追加・削除を行う

### 追加を行う

```shell
# 追加する前の確認をする
uv tree

# メインの依存パッケージの場合
uv add django pandas

# 開発・CIに利用するパッケージの場合
uv add --group dev ruff pytest

# 追加されたか確認をする
uv tree
```

### 削除を行う

```shell
# 削除する前の確認をする
uv tree

# メインの依存パッケージの場合
uv remove django pandas

# 開発・CIに利用するパッケージの場合
uv remove --group dev ruff pytest

# 削除されたか確認をする
uv tree
```

## パッケージのアップデート

pyproject.tomlに書かれている範囲内ですべて一括でアップデートする場合

```shell
uv sync --upgrade
```

pyproject.tomlに書かれている範囲内で特定のパッケージのみをアップデートする場合

```shell
uv sync --upgrade-package {パッケージ名}
```

pyproject.tomlに書かれているバージョンを更新してアップデートする場合

```shell
uv add "{パッケージ名}>=x.y.z"  # 新しいバージョンを指定する
```

## requirements.txtをエクスポートする

```shell
# メインのパッケージのみを出力する場合
uv export --no-dev --format requirements.txt --output-file requirements.txt
# 開発用のパッケージも含めて出力する場合
uv export --format requirements.txt --output-file requirements_with_dev.txt
```

`--output-file`の後ろに出力するファイル名を指定する。

## 既存プロジェクトの環境構築

```shell
# 既存プロジェクトフォルダに移動する
cd some-project

# 仮想環境構築とパッケージインストールを行う
uv sync
```

## uv自身のバージョンアップ

ツール自身のバージョンアップを行う。

```shell
uv self update
```

## キャッシュクリア

キャッシュ起因のエラー解消や端末の空き容量を増やすために、キャッシュをクリアする。

```shell
uv cache clean
```