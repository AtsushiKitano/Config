# macOS 開発環境 使い方ガイド

生産性とクラウド作業効率の向上のために整備したツール・設定の使い方をまとめる。
対象は dotfiles（`~/.conf`）配下の zsh 設定・Brewfile・mise・gcloud 構成。

> 反映方法: 設定変更後は新しいシェルを開くか `exec zsh` を実行する。

## 目次

- [1. gcloud 環境・プロジェクト切替](#1-gcloud-環境プロジェクト切替)
- [2. fzf（ファジーファインダ）](#2-fzfファジーファインダ)
- [3. zoxide（賢いディレクトリ移動）](#3-zoxide賢いディレクトリ移動)
- [4. eza（ls 代替）](#4-ezals-代替)
- [5. delta（git 差分表示）](#5-deltagit-差分表示)
- [6. direnv（ディレクトリ単位の環境変数）](#6-direnvディレクトリ単位の環境変数)
- [7. mise（バージョン管理）](#7-miseバージョン管理)
- [8. Brewfile（再現性）](#8-brewfile再現性)
- [補足](#補足)

---

## 1. gcloud 環境・プロジェクト切替

DAE 関連プロジェクトの gcloud 構成（configuration）を作成済み。構成を切り替えることで、アカウント・プロジェクトをまとめて変更できる。

### 作成済みの構成

| 構成名 | プロジェクト |
|--------|--------------|
| `default` | `be-kitano-atsushi`（個人） |
| `ai-mlops-dev` | `ai-mlops-dev` |
| `ai-mlops-stg` | `ai-mlops-stg` |
| `ai-mlops-prd` | `ai-mlops-prd` |
| `dmm-dae-admin` | `dmm-dae-admin` |
| `dmm-dae-dns` | `dmm-dae-dns` |

### コマンド（関数）

| コマンド | 説明 |
|----------|------|
| `gcswitch` | 構成（configuration）を fzf で選んで切り替える |
| `gcproj` | 現在の構成のプロジェクトを fzf で選んで切り替える |
| `gcimp <SA メール>` | サービスアカウントの impersonation を設定（引数なしで解除） |

```sh
# 構成を選んで切り替え（矢印/入力で絞り込み → Enter）
gcswitch

# 一時的に SA になりすまして実行（キーレス運用。鍵ファイル不要）
gcimp my-sa@my-project.iam.gserviceaccount.com
gcloud storage ls          # SA 権限で実行される
gcimp                       # impersonation を解除

# 現在の構成を確認
gcloud config configurations list
```

> **キーレス運用**: SA キーを発行せず、ADC（`gcloud auth application-default login`）と impersonation を使う。アカウント・権限ポリシー（最小権限・パスワード認証を避ける方針）とも整合する。

---

## 2. fzf（ファジーファインダ）

キーバインドを追加済み。**`Ctrl-R`（履歴）は従来どおり peco** を維持している。

| キー | 動作 |
|------|------|
| `Ctrl-T` | カレント配下のファイルを fzf で選択し、コマンドラインに挿入 |
| `Alt-C` | サブディレクトリを fzf で選んで `cd` |
| `Ctrl-R` | コマンド履歴検索（**peco**。fzf では上書きしていない） |
| `**<Tab>` | fzf 補完（例: `cd **<Tab>`、`kill **<Tab>`） |

検索には `fd` を使用（隠しファイル含む・`.git` 除外）。デフォルト表示は `--height 40% --reverse --border`。

---

## 3. zoxide（賢いディレクトリ移動）

訪問履歴を学習し、部分文字列で素早く移動できる。

| コマンド | 説明 |
|----------|------|
| `z <キーワード>` | 履歴から最適なディレクトリへ移動（例: `z dae` → `…/dmm-com/dae-team`） |
| `zi` | 候補を fzf で選んで移動 |

```sh
z dae        # 部分一致でジャンプ
z dmm com    # 複数キーワードで絞り込み
zi           # インタラクティブ選択
```

---

## 4. eza（ls 代替）

| エイリアス | 内容 |
|------------|------|
| `ls` | `eza --group-directories-first` |
| `ll` | `eza -l --git --group-directories-first`（詳細＋git 状態） |
| `la` | `eza -la --git --group-directories-first`（隠しファイル含む） |
| `lt` | `eza --tree --level=2`（ツリー表示） |

---

## 5. delta（git 差分表示）

git の差分・マージ表示を見やすくする。`~/.gitconfig`（dotfiles 管理）に設定済み。

- `git diff` / `git show` / `git log -p` が delta 表示になる
- 行番号表示・`navigate`（`n`/`N` で差分間移動）有効
- マージ競合は `zdiff3` スタイル

特別な操作は不要。通常どおり git を使えば反映される。

---

## 6. direnv（ディレクトリ単位の環境変数）

リポジトリ直下に `.envrc` を置くと、`cd` した時に自動で環境変数を読み込む。

```sh
# 例: リポジトリごとに gcloud プロジェクトを固定
cd ~/path/to/repo
echo 'export GOOGLE_CLOUD_PROJECT=ai-mlops-dev' > .envrc
direnv allow      # 初回のみ承認（.envrc 変更時も都度 allow が必要）
```

> `.envrc` はリポジトリにコミットしない情報（個人のプロジェクト指定など）に使う。共有が必要なら `.envrc.example` を用意する運用が安全。

---

## 7. mise（バージョン管理）

言語・ツールのバージョンを mise に**一本化**（asdf は廃止）。グローバル定義は dotfiles 管理。

- 設定ファイル: `~/.config/mise/config.toml`（→ `~/.conf/dotfiles/mise/config.toml`）
- 管理対象: node / python / terraform / terragrunt / ruff / npm パッケージ 等

```sh
mise ls --current          # 現在有効なバージョン一覧
mise use -g terraform@1.15  # グローバルにバージョン指定
mise use terraform@1.14     # カレントディレクトリ用に指定（mise.toml 生成）
mise install               # 設定に従ってインストール
```

> 旧 `~/.tool-versions` は `~/.tool-versions.bak` に退避済み。バージョン定義は `config.toml` が単一の正。

---

## 8. Brewfile（再現性）

インストール済みパッケージは `~/.conf/dotfiles/.Brewfile` で管理。新しい環境を再現できる。

```sh
# Brewfile に従ってインストール
brew bundle --file ~/.conf/dotfiles/.Brewfile

# 現在の状態を Brewfile に書き出す（更新時）
brew bundle dump --file ~/.conf/dotfiles/.Brewfile --force

# Brewfile に無いものを削除（注意して実行）
brew bundle cleanup --file ~/.conf/dotfiles/.Brewfile
```

> 新規ツールを `brew install` したら **Brewfile にも追記**する（追記しないと `cleanup` で消える）。

---

## 補足

- **設定の反映**: 変更後は `exec zsh` か新しいシェルを開く。
- **プロンプト**: Powerlevel10k（starship は未使用のため削除済み）。
- **dotfiles**: `~/.conf`（git 管理）。設定変更はコミットして履歴を残す。
- **関連ファイル**:
  - `~/.conf/dotfiles/.zsh_main` … fzf / zoxide / direnv / mise の初期化
  - `~/.conf/dotfiles/.zsh_function` … `gcswitch` / `gcproj` / `gcimp`
  - `~/.conf/dotfiles/.zsh_alias` … eza 等のエイリアス
  - `~/.conf/dotfiles/.gitconfig` … delta 設定
  - `~/.conf/dotfiles/.Brewfile` … パッケージ一覧
  - `~/.conf/dotfiles/mise/config.toml` … バージョン定義
