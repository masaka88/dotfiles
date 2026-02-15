---
name: create-pr
description: PRを作成する。変更を論理単位でコミット分割し、gh pr createでPRを作成する。
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh pr *)
---

# PR作成ワークフロー

## Step 1: 変更内容の把握

<current_changes>
!`git diff --stat`
</current_changes>

<recent_commits>
!`git log --oneline -10`
</recent_commits>

上記の変更内容を分析し、Step 2に進む。
追加の詳細が必要なら `git diff` や `git status` を実行して確認する。

## Step 2: コミットの分割計画

変更を論理単位でグループ分けする。分割の判断基準:

- **設定変更** と **コード変更** は別コミット
- **スタイル/フォーマットのみの変更** は別コミット
- **リファクタリング** と **機能追加** は別コミット
- **テスト追加** は対応する実装と同じコミットにまとめてよい
- **CI/ワークフロー変更** は別コミット
- **ドキュメント変更** は別コミット

各コミットが単独で意味を持ち、レビューしやすい単位にする。
分割計画をユーザーに提示して確認を取ってから Step 3 に進む。

## Step 3: コミットの作成

グループごとに以下を繰り返す:

1. 関連ファイルを `git add <files>` でステージング（`git add .` は使わない）
2. Conventional Commits形式でメッセージを作成:
   - `feat:` 新機能 / `fix:` バグ修正 / `refactor:` リファクタリング
   - `style:` フォーマットのみ / `test:` テスト / `docs:` ドキュメント
   - `ci:` CI/CD / `config:` / `chore:` 設定・雑務
3. `git commit` を実行

## Step 4: ブランチ作成・プッシュ・PR作成

1. ブランチを作成: `git checkout -b <type>/<short-description>`
2. プッシュ: `git push -u origin <branch>`
3. `gh pr create` でPRを作成。本文にはSummaryとTest planを含める
4. PR URLをユーザーに提示する
