---
name: emacs-config
description: Use this skill whenever editing this repo's Emacs configuration, diagnosing an Eglot/LSP "gopls"/"pyright"/"typescript-language-server" not found or file-missing error, adding a new leaf package, or making a CLI tool's binary visible to Emacs (exec-path/PATH). Triggers on "init.org", "init.el", "early-init.el", "leaf", "eglot", "gopls", "lsp-mode", "exec-path", or Emacs failing to find a program that works fine in the shell.
---

# Emacs 設定編集

このリポジトリ（`~/.conf`）の Emacs 設定は `Emacs/init.org` の org-babel コードブロック
が正本（single source of truth）。`~/.emacs.d/init.el` と `~/.emacs.d/early-init.el` は
`make link-emacs` による tangle 生成物で、直接編集しても次回 tangle で消える。

## 編集の手順

1. `Emacs/init.org` の該当セクション（`leaf` ブロック、パス設定ブロックなど）を編集する。
   `~/.emacs.d/init.el` を直接 Edit/Write しない。
2. リポジトリルート（`~/.conf`）で反映する。

   ```sh
   make link-emacs
   ```

   新規パッケージ（`leaf ... :ensure t`）を追加した場合はさらに:

   ```sh
   make emacs-install   # MELPA から取得 + native-compile
   ```

3. 反映確認（生成物に意図した内容が入っているか grep で確認できる）。

   ```sh
   grep -n "<追加したキーワード>" ~/.emacs.d/init.el
   ```

4. Emacs を再起動するか `M-x load-file ~/.emacs.d/init.el` で読み込ませる。

## Eglot/LSP が "gopls" 等を見つけられない場合

`(file-missing "Searching for program" "No such file or directory" "gopls")` のような
エラーは、バイナリ自体が無いか、**PATH には入っているが Emacs の `exec-path` には
入っていない**のが原因であることが多い。

原因の切り分け:

```sh
which gopls                 # シェルの PATH で見つかるか
go env GOPATH GOBIN         # go install の設置先を確認
```

Emacs（特に GUI 起動や `emacsclient` で使う daemon）は **zsh の `.zshrc` / `.zshenv` を
読まない**。したがってシェルの PATH を直しても Emacs からは見えない。
`Emacs/init.org` には同じ問題への対処として次のパターンのブロックが
複数存在する（mise shims / Homebrew bin / BasicTeX bin / Go bin）。

```emacs-lisp
(let ((tool-bin (expand-file-name "path/to/bin" "~")))
  (when (file-directory-p tool-bin)
    (add-to-list 'exec-path tool-bin)
    (setenv "PATH" (concat tool-bin ":" (getenv "PATH")))))
```

新しいツールのバイナリを Emacs から使えるようにするときは、既存ブロックの直後
（`** Go パスの設定` セクションなど）に同じ形で追記し、`add-to-list 'exec-path`
（Emacs の子プロセス起動用）と `setenv "PATH"`（`shell-command` 等のサブプロセス用）
の**両方**を必ず設定する。片方だけだと一部の呼び出し経路でだけ失敗する。

## その他の注意

- `debug-on-error` は `early-init.el` で早期に有効化されているため、
  `make emacs-install` では `-Q` 起動後にいったん `nil` にしてから `init.el` を
  load している（Makefile 参照）。バッチ検証で真似る場合も同様にする。
- 詳細な設計要件（leaf/evil/skk/corfu などの方針）は `Emacs/CLAUDE.md` を参照。
