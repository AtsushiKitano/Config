# 環境の設定

MacOS と Linux OSの設定を管理する

## 設計

### 初期起動

$HOME/.conf に作成される

### zsh

zshの設定は複数に分ける

- .zshrc: 大元の設定、各.zshファイルの呼び出し
- .zsh_main: 環境変数の設定
- .zsh_alias: aliasの設定
- .zsh_path: PATHの設定
- .zsh_function: zshの設定で使う関数の設定
- .zsh_option: option設定

### Emacs

- init.org のみ編集
- init.el は修正しない
- init.el は emacs --batch --eval でコンパイルにより生成

## よく使う関数

| コマンド                                                                                              | 説明                        |
|-------------------------------------------------------------------------------------------------------|-----------------------------|
| emacs --batch --eval "(require 'ob-tangle)" --eval '(org-babel-tangle-file "~/.conf/Emacs/init.org")' | init.org から init.elへのコンパイル |
