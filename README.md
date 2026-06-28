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
│   └── mise/          # mise (ランタイム管理)
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

### 2. リポジトリをクローン

```sh
git clone <repo-url> ~/.conf
cd ~/.conf
```

### 3. ブートストラップ実行

Homebrew インストールから設定ファイル配置・パッケージインストール・サービス起動まで一括で行う。

```sh
make bootstrap
```

内部では以下の順で実行される。

| ステップ | 内容 |
|---|---|
| `homebrew` | Homebrew 未導入なら公式インストーラを実行 |
| `link-pre` | `.Brewfile` と mise 設定を先に symlink (次の `install` がこれらを必要とするため) |
| `install` | `scripts/brew.sh` (`brew bundle`) と `scripts/mise.sh` (`mise install`) を実行 |
| `link` | Emacs (init.org → init.el を tangle) ほか全設定の symlink を張る |
| `emacs-install` | `emacs --batch` で `init.el` を読み込み、leaf 管理パッケージ (約 150 個) を MELPA から事前ダウンロード |
| `macos-defaults` | キーリピート速度・Dock・スクリーンショット保存先など macOS システム設定を適用 |
| `services` | yabai / skhd を `brew services` で起動 |

`scripts/brew.sh` の冒頭で外部 tap (`koekeishiya/formulae`, `d12frosted/emacs-plus` 等) は自動で `brew trust` され、`HOMEBREW_CASK_OPTS="--force"` により手動インストール済みアプリと衝突しても上書きされる。

---

## make ターゲット一覧

```sh
make bootstrap      # 新規 Mac: homebrew + link-pre + install + link + emacs-install + macos-defaults + services
make sync           # 既存 Mac: link + install + emacs-install + macos-defaults + services
make setup          # link のみ (パッケージインストールなし)
make link           # 全シンボリックリンクを作成
make emacs-install  # init.el を batch で読み込み leaf パッケージを事前ダウンロード
make macos-defaults # macOS システム設定を適用
make install        # Homebrew + mise インストール
make services       # yabai / skhd を起動
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

**`init.org` のみ編集する。`init.el` / `early-init.el` は直接編集しない (自動生成)。**

`init.org` を編集したら `make link-emacs` でタングルする。
`emacs --batch` で `init.org` を org-babel-tangle し、`~/.emacs.d/init.el` と
`~/.emacs.d/early-init.el` を上書きする。

```sh
make link-emacs
```

native compilation (`libgccjit`) は Homebrew の `gcc` が新しくなると
`emutls_w` を見つけられなくなるため、`early-init.el` で `LIBRARY_PATH` を
自動補完している (`init.org` の「native-comp のリンカパス (macOS)」セクション)。
新規 Mac でも emacs-plus 依存の `gcc` / `libgccjit` がインストールされれば
自動で機能する。

#### パッケージの再現

`leaf` で管理する MELPA パッケージは `make emacs-install` で `emacs --batch`
経由で事前インストールできる。`make bootstrap` / `make sync` の中で自動的に
呼び出されるので、新規 Mac でも初回起動時に体感ラグなく利用できる。

```sh
make emacs-install   # ~/.emacs.d/elpa/ に leaf 宣言済みパッケージを一括取得
```

なお `~/.emacs.d/elpa/` および `~/.emacs.d/eln-cache/` は OS / アーキテクチャ
依存のため repo には含めない。`make emacs-install` で都度ダウンロード・
ネイティブコンパイルを再現する。

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
