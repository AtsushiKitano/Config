# .conf

macOS の環境設定を管理する dotfiles リポジトリ。

## ディレクトリ構成

```
.conf/
├── dotfiles/          # $HOME に直接リンクする dotfiles
│   ├── .zshrc / .zshenv / .zsh_* 
│   ├── .gitconfig / .gitignore_global
│   ├── .tmux.conf
│   ├── .yabairc / .skhdrc
│   ├── .Brewfile
│   ├── mise/          # mise (ランタイム管理)
│   └── wezterm*.lua
├── Emacs/             # Emacs 設定 (init.org が正)
├── macos/
│   ├── TilingWindow-Yabai/   # yabai / skhd
│   ├── Karabiner/            # Karabiner-Elements
│   ├── AquaSKK/              # AquaSKK
│   └── init.sh               # macOS システム設定
└── scripts/           # セットアップスクリプト
```

## 初期セットアップ

### 1. Xcode Command Line Tools

```sh
xcode-select --install
```

### 2. Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homebrew/install/HEAD/install.sh)"
```

### 3. リポジトリをクローン

```sh
git clone <repo-url> ~/.conf
cd ~/.conf
```

### 4. セットアップ実行

シンボリックリンク作成・macOS 設定・パッケージインストールを一括で行う。

```sh
make all
```

内部では以下の順で実行される。

| ステップ | 内容 |
|---|---|
| `make link` | 各ツールの設定ファイルをシンボリックリンクで配置 |
| `make macos-defaults` | キーリピート速度・Dock・スクリーンショット保存先など macOS システム設定を適用 |
| `make install` | Homebrew パッケージ (`.Brewfile`) と mise ランタイムをインストール |

---

## make ターゲット一覧

```sh
make all            # link + macos-defaults + install (フルセットアップ)
make setup          # link のみ (パッケージインストールなし)
make link           # 全シンボリックリンクを作成
make macos-defaults # macOS システム設定を適用
make install        # Homebrew + mise インストール
```

```sh
make setup-slack    # Slack 認証情報を ~/.authinfo に書き込む
```

リンクは個別に実行することもできる。

```sh
make link-dotfiles    # dotfiles/.??* → $HOME
make link-emacs       # Emacs/init.el, early-init.el → ~/.emacs.d/
make link-yabai       # yabairc → ~/.config/yabai/, skhdrc → ~/.config/skhd/
make link-karabiner   # karabiner.json → ~/.config/karabiner/
make link-kitty       # kitty.conf → ~/.config/kitty/
make link-wezterm     # wezterm*.lua → ~/.config/wezterm/
make link-mise        # mise/config.toml → ~/.config/mise/
make link-aquaskk     # AquaSKK ルール → ~/Library/Application Support/AquaSKK/
```

---

## ツール別メモ

### zsh

`~/.zshrc` が各設定ファイルを読み込む構成。

| ファイル | 役割 |
|---|---|
| `.zshrc` | エントリーポイント。各ファイルを source する |
| `.zshenv` | 環境変数 |
| `.zsh_main` | PATH など基本設定 |
| `.zsh_alias` | エイリアス |
| `.zsh_function` | zsh 関数 |
| `.zsh_option` | setopt などオプション設定 |

### Emacs

**`init.org` のみ編集する。`init.el` は直接編集しない。**

`init.el` は `init.org` から org-babel-tangle で生成する。

```sh
# init.org → init.el に変換
emacs --batch --eval "(require 'ob-tangle)" \
      --eval '(org-babel-tangle-file "~/.conf/Emacs/init.org")'

# または Emacs/Makefile を使う
make -C Emacs
```

### yabai / skhd

`make link-yabai` で以下にリンクされる。

- `~/.config/yabai/yabairc`
- `~/.config/skhd/skhdrc`

yabai は SIP (System Integrity Protection) の部分無効化が必要な場合がある。
詳細は [yabai wiki](https://github.com/koekeishiya/yabai/wiki) を参照。

### Slack (emacs-slack)

Emacs から Slack を使うための初期設定。

#### 1. トークンの取得

ブラウザで `https://app.slack.com` を開き、開発者ツール（`Cmd+Option+I`）を起動する。

**トークン (`xoxc-`)**: Console タブで以下を実行してコピーする。

```javascript
JSON.parse(localStorage.localConfig_v2).teams[Object.keys(JSON.parse(localStorage.localConfig_v2).teams)[0]].token
```

**Cookie (`xoxd-`)**: Application タブ → Cookies → `https://app.slack.com` → 名前が `d` の行の Value をコピーする。

#### 2. 認証情報の設定

スクリプトで対話的に `~/.authinfo` に書き込む。

```sh
make setup-slack
```

プロンプトに従い、メールアドレス・トークン・Cookie を入力する。

#### 3. Emacs から接続

Emacs を起動し `C-c s s` で接続する。

#### キーバインド

| キー | 用途 |
|---|---|
| `C-c s s` | 接続 |
| `C-c s c` | チャンネルを開く |
| `C-c s m` | DM を開く |
| `C-c C-j` | メッセージ入力欄を開く（バッファ内） |
| `C-c C-c` | メッセージ送信（入力欄内） |

---

### mise (ランタイム管理)

インストール済みランタイムは `dotfiles/mise/config.toml` で管理。

```toml
[tools]
node    = "25.2.1"
python  = "3.12.4"
```

`make install` 実行時に `mise install` が走り、記載されたバージョンが自動インストールされる。
