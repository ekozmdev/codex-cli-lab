# uv インストール (Windows)

## 目的

Windows 環境で Python プロジェクトを管理するために、パッケージマネージャーの uv をユーザー権限でセットアップする。

## 手順

1. PowerShell を通常権限で起動し、インストールスクリプトを実行する。
   ```powershell
   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
   ```
2. インストール後に `C:\Users\<ユーザー名>\.local\bin` がユーザー環境変数 `Path` に含まれているか確認し、未登録なら次の手順で追加する。
   - Windows キーを押し、「環境変数」を検索して「環境変数を編集」を開く。
   - 「ユーザー環境変数」で `Path` を選び、「編集」→「新規」をクリック。
   - `C:\Users\<ユーザー名>\.local\bin` もしくは `%USERPROFILE%\.local\bin` を入力し、すべてのダイアログで OK を押して反映する。
3. 新しい PowerShell セッションでインストール結果を確認する。
   ```powershell
   uv --version
   ```

## 注意点

- 企業ネットワークなどプロキシ環境では、事前に `irm` コマンド（`Invoke-RestMethod`）が外部 URL に到達できるか確認する。
- uv のインストーラーやオプションは更新されるため、必ず Astral の公式ドキュメントで最新情報を確認する。  
  <https://docs.astral.sh/uv/getting-started/installation/>
