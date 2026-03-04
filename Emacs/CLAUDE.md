# Emacs init.el 設定要件

## 概要

init.el をゼロから書き直す。`leaf` でパッケージ管理する。

## パッケージ管理

- パッケージマネージャ: `leaf` + `leaf-keywords`
- アーカイブ: gnu / melpa / org / nongnu
- 依存: hydra, el-get, blackout

---

## UI / テーマ

- テーマ: `doom-themes` (doom-tomorrow-night)
  - bold / italic は無効
  - neotree / org の設定を有効化
- モードライン: `mood-line`（doom-modeline から変更）
- アイコン: `all-the-icons`
- フォント: `Monospace-18`
- フレーム透明度: `alpha 85`
- メニューバー・ツールバー・スクロールバー: 非表示
- 行番号: `global-display-line-numbers-mode` で表示
  - 現在行番号の色: gold
- カーソル点滅: なし（`blink-cursor-mode 0`）
- フレームタイトル: ファイルパス表示（`%f`）

---

## 入力・操作

### Evil モード

- `evil` を有効にして Vim キーバインドを使う
- 挿入モードでも Emacs キーバインドを使えるようにする
  - `C-p/n`: 前後の行
  - `C-b/f`: 前後の文字
  - `C-a/e`: 行頭 / 行末
  - `M-f/b`: 単語移動
  - `C-d`: 文字削除
  - `C-h`: `backward-delete-char`
  - `C-k`: `kill-line`
  - `C-w`: `backward-kill-word`
  - `C-y`: yank
  - `M-d`: `kill-word`
  - `C-g`: ノーマルモードに戻る
- 以下のモードでは emacs state で起動
  - `vterm-mode`, `dired-mode`, `magit-mode`, `imenu-list-major-mode`, `eat-mode`

### グローバルキーバインド

| キー         | コマンド                         |
|-------------|--------------------------------|
| `C-h`       | `backward-delete-char`         |
| `M-h`       | `previous-multiframe-window`   |
| `M-l`       | `next-multiframe-window`       |
| `M-z`       | `delete-other-windows`         |
| `C-a`       | `mwim-beginning-of-code-or-line` |
| `C-e`       | `mwim-end-of-code-or-line`     |
| `C-{`       | `hs-hide-block`                |
| `C-}`       | `hs-show-block`                |
| `¥`         | `\` に置き換え                  |
| `C-x g`     | `magit-status`                 |
| `M-t`       | `vterm`                        |
| `C-c t`     | `eat`                          |
| `M-n`       | `flycheck-next-error`          |
| `M-p`       | `flycheck-previous-error`      |
| `C-c C-'`   | `claude-code-ide-menu`         |

### 括弧・ペア管理 (smartparens)

- 括弧・クォートを入力すると自動で閉じる（`electric-pair-mode` は無効）
- 移動コマンド: `C-M-a/e/d/u/w/q/f/b/n/p`, `C-s-f/b`
- wrap: `C-c (/{/[/'/"`, unwrap: `M-]`, kill: `M-k`
- Go: `{` 後改行でインデント
- TSX/JSX: `{` 後スペース挿入、`< >` ペア有効

### 日本語入力 (ddskk)

- AZIK 使用（`jp106` キーボード）
- `C-x C-j` / `M-j` で SKK モード起動
- `skk-egg-like-newline`, `skk-show-inline` 等の設定を維持
- `skk-preload`: t

---

## 補完フレームワーク（ivy/counsel → vertico/corfu に移行）

### ミニバッファ補完

- `vertico`: 縦方向の候補表示
- `consult`: 検索・ナビゲーション
  - `C-s`: `consult-line`（swiper の代替）
  - `C-x C-r`: `consult-recentf`
  - `C-S-s`: `consult-imenu`
- `orderless`: スペース区切りで複数キーワード絞り込み
- `marginalia`: 候補の詳細情報を横に表示

### インライン補完

- `corfu`: コード補完（company の代替）
  - `idle-delay`: 0
  - `minimum-prefix-length`: 1
- `cape`: 補完ソース追加（dabbrev, file 等）
- yasnippet との連携を維持

---

## 文法チェック (flycheck)

- `global-flycheck-mode` で有効化
- `flycheck-inline`: インラインエラー表示（GUI のみ）
- `flycheck-color-mode-line`: モードラインの色変化
- エラー表示遅延: 0.3s

---

## LSP (lsp-mode 継続)

- `lsp-mode` + `lsp-ui` を使用
- LSP プレフィックス: `C-c l`
- `lsp-ui-peek` で定義ジャンプ・参照検索
- `lsp-ui-doc-position`: bottom
- breadcrumb 有効
- hydra で LSP コマンドをまとめる（`s-l`）
- `lsp-treemacs` でエラーリスト表示

---

## TreeSitter

- `treesitter-auto` で各言語の ts-mode に自動切り替え
- 対象言語: go, tsx, typescript, python, yaml 等

---

## Git 管理

- `magit`: `C-x g` で magit-status
- `git-gutter-fringe`: 変更行を fringe に表示

---

## ターミナル

### eat（メイン）

- `C-c t` で起動、バッファに展開
- `C-h` で backspace 送信
- evil emacs state で起動
- `eat-kill-buffer-on-exit`: t
- マウス有効

### vterm（補助）

- `M-t` で起動
- `vterm-toggle` で下部に表示（高さ 40%）
- `C-h` で backspace 送信
- evil emacs state で起動

---

## スニペット (yasnippet)

- `yasnippet` + `yasnippet-snippets`
- `yatemplate` でテンプレート管理
- キーバインド（`C-c y i/n/v/l/g`）

---

## プログラミング言語

### Go

- `treesitter-auto` → `go-ts-mode`
- LSP: `lsp-mode` (gopls)
  - `unusedparams`, `unusedwrite` アナライザ有効
- フォーマッタ: `goimports`（`reformatter` 経由）
- 保存時: 自動フォーマット + import 整理
- `tab-width`: 4, `indent-tabs-mode`: t

### TypeScript / JavaScript

- `treesitter-auto` → `tsx-ts-mode`, `typescript-ts-mode`
- LSP: `lsp-mode`
- フォーマッタ: `prettier`（`reformatter` 経由）
- 保存時: 自動フォーマット

### Python

- `treesitter-auto` → `python-ts-mode`
- LSP: `lsp-pyright`
- フォーマッタ: `ruff`（`reformatter` 経由）
- 保存時: 自動フォーマット
- `blacken`: 補助的に利用

### Terraform

- `terraform-mode`
- LSP: `lsp-deferred`
- 保存時: 自動フォーマット

### その他

- `yaml-mode`
- `dockerfile-mode`
- `json-mode`（インデント 2 スペース）
- `graphql-mode`（インデント 2 スペース）
- `prisma-mode`（VC 経由でインストール）
- `markdown-mode`（`.md` → `gfm-mode`）

---

## コードフォーマット (reformatter)

| 言語              | ツール       |
|-----------------|------------|
| Go              | goimports  |
| TypeScript/Web  | prettier   |
| Python          | ruff       |

---

## UI 補助

- `rainbow-delimiters`: 括弧の深さで色分け
- `whitespace-mode`: 全角スペース・タブ等の可視化
  - 対象: emacs-lisp, shell-script, sh, python, org
- `imenu-list`: 左サイドに imenu 表示
  - `hide-mode-line` で imenu-list のモードラインを非表示
- `all-the-icons`: アイコン表示

---

## 一般設定

- `lexical-binding`: t
- `mac-command-modifier`: meta
- `mac-option-key-is-meta`: nil
- 大きなファイル警告: 25MB
- 自動保存: 有効（`backup/` ディレクトリ）
- バックアップ: 有効（バージョン管理、古いものを削除）
- `auto-revert`: 有効（1 秒間隔）
- `yes-or-no-p` → `y-or-n-p`
- 括弧ハイライト: `show-paren-mode`（delay 0.1）
- `visual-line-mode`: グローバルで有効
- タブ: スペースで代替（デフォルト 2 スペース、Go は 4）
- 履歴: 1000 件（重複削除）
- `recentf`: 1000 件
- スクロール: 保持, conservatively 100
- リージョン選択時に挿入で削除: `delete-selection-mode`
- ベルを無効化: `ring-bell-function` → ignore
- ユーザ情報: Atsushi Kitano / atsushi@aquamarine-cloud.net

---

## Claude Code IDE

- `claude-code-ide.el` を VC 経由でインストール
- `C-c C-' ` で IDE メニュー表示
- `claude-code-ide-emacs-tools-setup` を実行
