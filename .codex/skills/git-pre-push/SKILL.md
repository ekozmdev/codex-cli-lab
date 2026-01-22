---
name: git-pre-push
description: --no-pager の status / diff を使ってプッシュ前に確認するためのスキル。ユーザーが「プッシュして」「公開して」「push したい」と言ったときに使う。main に push する場合は必ず確認する。
---

# Git Pre Push

## 概要

プッシュ前に no-pager の Git 確認を行い、main への push は必ず確認を取る。

## 手順

1. 下のコマンドを順番に実行する。
2. status 出力から現在ブランチを特定する。
3. main の場合は push 前に明示的な確認を取る。
4. 含まれるコミットを簡潔に説明する。
5. 確認内容を要約し、ユーザーの承諾後にのみ進める。

## コマンド（順番どおりに実行）

```sh
git --no-pager status --short --branch
git --no-pager diff
git --no-pager log --oneline --decorate --reverse @{u}..HEAD
```

## 注意

- status からブランチが分からない場合は次を実行する:
  ```sh
  git --no-pager branch --show-current
  ```
- 上流がない場合は `git --no-pager log --oneline --decorate -n 10` で直近を説明する。
- 含まれるコミットはタイトル中心で短くまとめる。
- ユーザーが確認するまで push しない。
