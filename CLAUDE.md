# .conf — dotfiles リポジトリ

macOS（一部 Linux/Manjaro）の環境設定を管理する dotfiles リポジトリ。
`$HOME/.conf` にクローンして使う。詳細なセットアップ手順・全 make ターゲット・
ツール別の使い方は `README.md` と `docs/macos-dev-environment.md` を参照。
このファイルは重複説明を避け、Claude が作業する上で守るべきルールと
どこに何があるかの索引に絞る。

## 最重要ルール

### Emacs 設定は init.org のみ編集する

- 編集してよいのは `Emacs/init.org` だけ。`~/.emacs.d/init.el` /
  `~/.emacs.d/early-init.el` は tangle による自動生成物なので**直接編集しない**
  （手で直しても次の tangle で上書きされて消える）。
- `init.org` を編集したら、リポジトリルートで必ず以下を実行して反映する。

  ```sh
  make link-emacs
  ```

- 新しい MELPA パッケージを追加した場合は `make emacs-install` も実行する
  （leaf 管理パッケージの事前ダウンロード + native-compile）。
- 反映後は Emacs 再起動、または `M-x load-file ~/.emacs.d/init.el` で確認する。
- Emacs 固有の設計要件・キーバインド・言語別 LSP 設定などは
  `Emacs/CLAUDE.md`（このディレクトリ配下で作業する際に自動で読み込まれる）を見る。
- **Emacs は GUI/daemon 起動のため zsh の `.zshrc` 等を読まない。**
  `go install` や他のツールが `$HOME/xxx/bin` のような PATH に無いディレクトリへ
  バイナリを置く場合、シェルの PATH を直しても Emacs（＝ eglot 経由の LSP）からは
  見えない。`Emacs/init.org` の「mise パスの設定」「Homebrew パスの設定」
  「BasicTeX パスの設定」「Go パスの設定」セクションと同じパターン
  （`add-to-list 'exec-path` + `setenv "PATH"`）で追記すること。
  手順は `.claude/skills/emacs-config/SKILL.md` にもまとめてある。

### システム状態を変更する make ターゲットは実行前に確認する

- `make bootstrap` / `make sync` / `make macos-defaults` / `make services` は
  ローカル環境の実状態を変更する（Homebrew インストール、`brew bundle` は
  `HOMEBREW_CASK_OPTS="--force"` で手動インストール済みアプリを上書き、
  `macos/init.sh` は `sudo` を使い `defaults write` でシステム設定を変更、
  launchd サービスの起動/再起動を行う）。
  これらは明示的な指示がない限り勝手に実行しない。
- 個別の `make link-*`（symlink 作成のみ）は副作用が小さく安全に再実行できる。

### 機密情報をコミットしない

- `.gitignore` で `*.key` `*secret*` `*token*` `.authinfo` `.netrc` 等を除外済み。
  Slack など認証情報が要るツールは `scripts/setup-slack.sh`（1Password CLI 経由）
  のようにリポジトリ外（`~/.authinfo` 等）に書き出す方式に従う。新しい認証情報を
  扱うスクリプトを追加するときも同じ方針にする。

## ディレクトリ構成（詳細は README.md）

| パス | 役割 |
|---|---|
| `dotfiles/` | `$HOME` に symlink する dotfiles（zsh, git, tmux, mise） |
| `Emacs/init.org` | Emacs 設定の正本。`Emacs/CLAUDE.md` に設計要件、`Emacs/docs/operations.md` に運用メモ |
| `macos/` | rift（タイリング WM）、Karabiner、macSKK、kitty、ghostty、`init.sh`（macOS defaults） |
| `Hammerspoon/` | ウィンドウフォーカス連動の入力ソース自動切り替え |
| `launchd/` | Emacs daemon / org-sync の launchd plist |
| `linux/manjaro/` | Manjaro 向け Ansible ベースのセットアップ（macOS の make フローとは別系統） |
| `scripts/` | `brew.sh` `mise.sh` `emacs-daemon.sh` `org-sync.sh` `setup-slack.sh` |
| `docs/macos-dev-environment.md` | gcloud / fzf / zoxide / eza / delta / direnv / mise / Brewfile の使い方ガイド |

## よく使う操作

まとまった一覧は `README.md` の「make ターゲット一覧」を参照。代表例のみ:

```sh
make link-emacs   # init.org を tangle して ~/.emacs.d/ に反映
make setup        # 全 symlink のみ張り直す（パッケージインストールなし、安全）
make sync         # 既存 Mac の設定・パッケージ・サービスを最新化（要確認）
```

## Claude Code 固有設定

- `.claude/settings.json`: OTEL テレメトリ、権限（allow/deny）、通知フック、
  ステータスラインなどプロジェクト共通設定。許可コマンドを増やす場合は
  `update-config` スキルを使う。
- Emacs 配下で作業するときは `Emacs/.claude/settings.local.json` と
  `Emacs/CLAUDE.md` が追加で読み込まれる。
