---
name: create-pr
description: PRを作成する。変更を論理単位でコミット分割し、gh pr createでPRを作成する。
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh pr *)
---

# PR作成ワークフロー

## Step 1: 現状把握

<current_branch>
!`git branch --show-current`
</current_branch>

<current_changes>
!`git diff --stat`
</current_changes>

<recent_commits>
!`git log --oneline -10`
</recent_commits>

上記の変更内容を分析し、Step 2に進む。
追加の詳細が必要なら `git diff` や `git status` を実行して確認する。

## Step 2: コミット分割計画とブランチ名の決定

変更を論理単位でグループ分けする。分割の判断基準:

- **設定変更** と **コード変更** は別コミット
- **スタイル/フォーマットのみの変更** は別コミット
- **リファクタリング** と **機能追加** は別コミット
- **テスト追加** は対応する実装と同じコミットにまとめてよい
- **CI/ワークフロー変更** は別コミット
- **ドキュメント変更** は別コミット

各コミットが単独で意味を持ち、レビューしやすい単位にする。
あわせてPR全体を表すブランチ名（`<type>/<short-description>`）も決定する。

**ブランチ名のtype選び**: コミットが複数typeに分かれる場合、PRの主目的（最も中心的な変更）のtypeを採用する。例えば新機能+ドキュメント+CI調整なら `feat/` を使う。PR全体が1つの目的を持つよう命名すること。

分割計画とブランチ名をユーザーに提示して確認を取ってから Step 3 に進む。

## Step 3: ブランチ作成（mainブランチ上にいる場合）

現在のブランチが `main` / `master` の場合は、**コミット作成前に必ず新ブランチを切る**:

```bash
git checkout -b <type>/<short-description>
```

すでにfeatureブランチ上にいる場合はこのステップをスキップする。

## Step 4: コミットの作成

グループごとに以下を繰り返す:

1. 関連ファイルを `git add <files>` でステージング（`git add .` は使わない）
2. Conventional Commits形式でメッセージを作成:
   - `feat:` 新機能 / `fix:` バグ修正 / `refactor:` リファクタリング
   - `style:` フォーマットのみ / `test:` テスト / `docs:` ドキュメント
   - `ci:` CI/CD / `config:` / `chore:` 設定・雑務
   - **body(本文)の扱い**: 変更理由や背景が非自明なときは1〜2行のbodyを添える。
     「何をしたか」はheaderで済むので、bodyには「なぜそうしたか」を書く。
     自明・単純な変更（typo修正など）はheaderのみでよい。
3. `git commit` を実行

## Step 5: プッシュ・PR作成

1. プッシュ: `git push -u origin <branch>`
2. `gh pr create` でPRを作成。PR本文は以下のテンプレートに従う:

   ```markdown
   ## Summary
   - <変更点を1-3行の箇条書き。「何を」「なぜ」を簡潔に>

   ## Test plan
   - [ ] <手動確認の手順やチェック項目を箇条書き>
   ```

   タイトルはPRの主目的を表すConventional Commits形式（例: `feat: add math_utils module`）。

3. PR URLをユーザーに提示する
