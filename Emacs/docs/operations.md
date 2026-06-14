# Emacs キーバインド一覧

> Emacs内から確認: `C-c H`

---

## グローバルキーバインド (カスタム)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-h` | `backward-delete-char` | カーソル前の文字を削除 |
| `C-d` | `delete-forward-char` | カーソル後の文字を削除 |
| `C-f` | `forward-char` | 1文字前進 |
| `C-k` | `kill-line` | 行末まで削除 |
| `C-e` | `move-end-of-line` | 行末へ移動 |
| `C-{` | `hs-hide-block` | コードブロックを折り畳む (prog-mode) |
| `C-}` | `hs-show-block` | コードブロックを展開する (prog-mode) |
| `C-<tab>` | `hs-toggle-hiding` | コードブロックの折り畳みトグル |
| `M-h` | `previous-multiframe-window` | 前のウィンドウへ移動 |
| `M-l` | `next-multiframe-window` | 次のウィンドウへ移動 |
| `M-z` | `my/toggle-zoom-window` | カレントウィンドウをズームトグル (tmux `C-z` 相当) |
| `M-%` | `anzu-query-replace` | インタラクティブ置換 |
| `C-c h` | `describe-bindings` | 現在のキーバインド一覧を表示 |
| `C-c H` | `my/show-keybindings` | このキーバインドドキュメントを表示 |
| `C-;` | `consult-buffer` | バッファ・ファイル・履歴を横断検索 |
| `C-x o` | `ace-window` | ウィンドウを選んで移動 |
| `C-x g` | `magit-status` | magit ステータスを開く |
| `C-c t` | `eat` | ターミナルを起動 |
| `C-c A` | `agent-shell` | Claude Code シェルを起動 |
| `C-c e` | `ellama-transient-main-menu` | ellama (LLM) メニューを開く |
| `C-c a` | `org-agenda` | Org アジェンダを開く |
| `C-c c` | `org-capture` | Org キャプチャ (テンプレート選択) |
| `C-c l` | `org-store-link` | Org リンクを保存 |
| `C-c o b` | `my/org-open-book` | book/ のファイルを選択/作成して開く |
| `C-c o w` | `my/org-open-work` | work/ のファイルを選択/作成して開く |
| `C-c o r` | `my/org-open-research` | research/ のファイルを選択/作成して開く |
| `C-c o s` | `my/org-sync` | org ファイルを GitHub へ手動同期 |
| `C-:` | `avy-goto-char-timer` | 文字を入力してジャンプ先を選択 |
| `C-*` | `avy-resume` | 直前の avy 操作を再開 |
| `M-g M-g` | `avy-goto-line` | 行番号指定でジャンプ |
| `C-.` | `er/expand-region` | 選択範囲を意味単位で拡大 |
| `M-1` ~ `M-9` | `winum-select-window-N` | 番号でウィンドウを直接選択 |
| `M-.` | `xref-find-definitions` | 定義へジャンプ |
| `M-?` | `xref-find-references` | 参照を一覧表示 |
| `M-,` | `xref-go-back` | ジャンプ前の位置へ戻る |
| `¥` | `\` | ¥ キーをバックスラッシュに置き換え |
| `mouse-2` | `mouse-yank-at-click` | クリック位置にペースト |
| `C-z` | (無効) | `suspend-frame` を無効化 |

---

## Evil モード

### Normal モード — 移動

| キー | 説明 |
|------|------|
| `h` / `j` / `k` / `l` | 左 / 下 / 上 / 右 |
| `w` / `b` | 次の単語先頭 / 前の単語先頭 |
| `e` | 次の単語末尾 |
| `W` / `B` / `E` | 空白区切りの単語移動 |
| `0` / `^` / `$` | 行頭(列0) / 行頭(空白スキップ) / 行末 |
| `gg` / `G` | バッファ先頭 / バッファ末尾 |
| `{` / `}` | 前の段落 / 次の段落 |
| `%` | 対応する括弧へジャンプ |
| `f<c>` / `F<c>` | 行内の文字 `<c>` へ前進 / 後進ジャンプ |
| `t<c>` / `T<c>` | `<c>` の直前 / 直後へジャンプ |
| `;` / `,` | `f/t` ジャンプを繰り返す / 逆方向に繰り返す |
| `H` / `M` / `L` | 画面上端 / 中央 / 下端へ移動 |
| `C-u` / `C-d` | 半画面上スクロール / 下スクロール |
| `C-f` / `C-b` | 1画面前進 / 後退 |
| `zt` / `zz` / `zb` | カーソル行を画面上端 / 中央 / 下端に |
| `'<m>` / `` `<m> `` | マーク `<m>` の行頭 / 正確な位置へジャンプ |
| `''` / ` `` ` | 直前ジャンプ位置に戻る |

### Normal モード — 編集

| キー | 説明 |
|------|------|
| `i` / `I` | カーソル位置 / 行頭でインサートモードへ |
| `a` / `A` | カーソル後 / 行末でインサートモードへ |
| `o` / `O` | 次行 / 前行に新規行を作りインサートモードへ |
| `s` / `S` | 1文字削除してインサート / 行全体を置換 |
| `r<c>` | カーソル文字を `<c>` に置換 |
| `R` | 上書きモードへ |
| `x` / `X` | カーソル文字を削除 / カーソル前の文字を削除 |
| `dd` | 行全体を削除 |
| `D` | 行末まで削除 |
| `cc` | 行全体を変更 (削除→インサート) |
| `C` | 行末まで変更 |
| `yy` / `Y` | 行全体をヤンク |
| `p` / `P` | カーソル後 / 前にペースト |
| `u` | アンドゥ |
| `C-r` | リドゥ |
| `~` | カーソル文字の大文字/小文字を切り替え |
| `gu<motion>` / `gU<motion>` | 小文字化 / 大文字化 |
| `>>` / `<<` | インデントを増やす / 減らす |
| `=<motion>` | インデントを自動整形 |
| `J` | 次行を現在行の末尾に結合 |
| `.` | 直前の編集操作を繰り返す |

### Normal モード — テキストオブジェクト (d/c/y と組み合わせ)

| キー | 対象 |
|------|------|
| `iw` / `aw` | 単語 (内側) / 単語 + 前後スペース |
| `is` / `as` | センテンス (内側 / 外側) |
| `ip` / `ap` | 段落 (内側 / 外側) |
| `i"` / `a"` | `"..."` の内側 / 外側 |
| `i'` / `a'` | `'...'` の内側 / 外側 |
| `` i` `` / `` a` `` | バッククォート内側 / 外側 |
| `i(` / `a(` | `(...)` の内側 / 外側 |
| `i[` / `a[` | `[...]` の内側 / 外側 |
| `i{` / `a{` | `{...}` の内側 / 外側 |
| `it` / `at` | HTML タグ内側 / 外側 |

例: `di"` → ダブルクォート内を削除、`ya{` → `{...}` 全体をヤンク、`ci(` → 括弧内を変更

### Normal モード — 検索

| キー | 説明 |
|------|------|
| `/` + `<pattern>` | 下方向へ検索 |
| `?` + `<pattern>` | 上方向へ検索 |
| `n` / `N` | 次のヒット / 前のヒット |
| `*` / `#` | カーソル下の単語を下 / 上方向へ検索 |
| `g*` / `g#` | 部分一致で下 / 上方向へ検索 |

### Normal モード — カスタムキーバインド

| キー | コマンド | 説明 |
|------|---------|------|
| `gd` | `xref-find-definitions` | 定義へジャンプ |
| `gr` | `xref-find-references` | 参照を一覧表示 |
| `C-t` | `xref-go-back` | ジャンプ前の位置へ戻る |
| `C-n` | `next-line` | 次の行へ |
| `C-p` | `previous-line` | 前の行へ |
| `C-w` | `my/kill-region-or-backward-kill-word` | リージョン切り取り / 単語後退削除 |
| `M-w` | `my/kill-ring-save-region` | リージョンコピー |
| `M-z` | `my/toggle-zoom-window` | ウィンドウズームトグル |
| `C-@` / `C-SPC` | `set-mark-command` | マークをセット |
| `<C-tab>` | `hs-toggle-hiding` | コードブロックの折り畳みトグル |

### Insert モード (Emacs キーバインド維持)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-p` | `previous-line` | 前の行へ |
| `C-n` | `next-line` | 次の行へ |
| `C-b` | `backward-char` | 1文字後退 |
| `C-f` | `forward-char` | 1文字前進 |
| `C-a` | `move-beginning-of-line` | 行頭へ |
| `C-e` | `move-end-of-line` | 行末へ |
| `M-f` | `forward-word` | 1単語前進 |
| `M-b` | `backward-word` | 1単語後退 |
| `C-d` | `delete-forward-char` | カーソル後の文字を削除 |
| `C-h` | `backward-delete-char` | カーソル前の文字を削除 |
| `C-k` | `kill-line` | 行末まで削除 |
| `C-w` | `my/kill-region-or-backward-kill-word` | リージョン切り取り / 単語後退削除 |
| `M-w` | `my/kill-ring-save-region` | リージョンコピー |
| `C-y` | `yank` | ペースト |
| `M-d` | `kill-word` | カーソル後の単語を削除 |
| `C-g` | `evil-normal-state` | ノーマルモードへ戻る |
| `C-@` / `C-SPC` | `set-mark-command` | マークをセット |
| `<C-tab>` | `hs-toggle-hiding` | コードブロックの折り畳みトグル |
| `RET` | `my/newline-and-indent-pair` | 括弧展開付き改行 (prog-mode) |

### Visual モード

| キー | 説明 |
|------|------|
| `v` / `V` / `C-v` | キャラクタ / ライン / ブロック ビジュアルモード |
| `o` | 選択範囲の反対端へカーソルを移動 |
| `gv` | 前回の選択範囲を再選択 |
| `>` / `<` | インデントを増やす / 減らす |
| `=` | インデントを自動整形 |
| `u` / `U` | 小文字化 / 大文字化 |
| `M-w` | `my/kill-ring-save-region` | 選択範囲をコピー |
| `C-w` | `my/kill-region-or-backward-kill-word` | 選択範囲を切り取り |

### コマンドライン (`:` モード)

| コマンド | 説明 |
|----------|------|
| `:w` | 保存 |
| `:q` / `:q!` | 終了 / 強制終了 |
| `:wq` / `ZZ` | 保存して終了 |
| `:e <file>` | ファイルを開く |
| `:%s/old/new/g` | バッファ全体で置換 |
| `:'<,'>s/old/new/g` | 選択範囲内で置換 |
| `:noh` | 検索ハイライトを消す |

### Emacs State (Evil 無効化モード)

以下のモードは Evil を無効化し、Emacs 標準キーバインドで動作する:
`vterm-mode`, `dired-mode`, `magit-mode`, `imenu-list-major-mode`, `eat-mode`, `agent-shell-mode`

---

## Org-mode

### グローバル起動キー

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c a` | `org-agenda` | アジェンダを開く |
| `C-c c` | `org-capture` | キャプチャ (テンプレート選択) |
| `C-c l` | `org-store-link` | カーソル位置のリンクを保存 |

### ディレクトリ別ファイル管理

org ファイルは領域ごとのディレクトリで管理する。各ディレクトリ配下の全 `.org` ファイルが自動的にアジェンダに登録される。

```
~/org/
├── book/        ← 本ごとに 1 ファイル  (例: book/llm-rag.org)
├── work/        ← 案件ごとに 1 ファイル (例: work/dmm.org)
├── research/    ← テーマごとに 1 ファイル (例: research/statistics.org)
├── personal/    ← 個人タスク・日記
├── shared/      ← デフォルト (memo.org / meetings.org)
└── archive.org  ← 完了タスクの自動アーカイブ先
```

**ファイルの選択/作成フロー (`C-c o` / `C-c c`):**

1. completing-read で既存ファイルを一覧表示
2. `[+ 新規作成]` を選ぶと名前を入力してファイルを作成
3. 新規ファイルには `#+title`, `#+filetags`, 初期見出しが自動挿入される

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c o b` | `my/org-open-book` | `book/` のファイルを選択/作成して開く |
| `C-c o w` | `my/org-open-work` | `work/` のファイルを選択/作成して開く |
| `C-c o r` | `my/org-open-research` | `research/` のファイルを選択/作成して開く |
| `C-c o s` | `my/org-sync` | `~/org` を GitHub へ手動同期 |

### キャプチャテンプレート (`C-c c` 後)

指定なし時は `shared/memo.org` がデフォルト。`b` / `w` / `r` / `p` はファイル選択ダイアログを経由する。

| キー | テンプレート | 保存先 |
|------|------------|--------|
| `m` | **Memo** (デフォルト) | `shared/memo.org` の Memo |
| `b` | **Book Note** | `book/<選択ファイル>` の Notes |
| `w` | **Work Task** | `work/<選択ファイル>` の Tasks |
| `W` | **Work Note** | `work/<選択ファイル>` の Notes |
| `r` | **Research Note** | `research/<選択ファイル>` の Notes |
| `R` | **Research Task** | `research/<選択ファイル>` の TODO Tasks |
| `p` | **Personal Task** | `personal/<選択ファイル>` の Tasks |
| `j` | **Journal** | `personal/journal.org` (日付ツリー) |
| `M` | **Meeting** | `shared/meetings.org` の Meetings |

**新規ファイル作成時の初期構造:**

| 領域 | 自動挿入される見出し |
|------|-------------------|
| book | `TODO Read` / `Notes` / `Review` |
| work | `Tasks` / `Notes` |
| research | `Overview` / `TODO Tasks` / `Notes` / `References` |
| personal | `Tasks` / `Notes` |

### TODO ステート

| ステート | 説明 |
|---------|------|
| `TODO` | 未着手 (ショートカット: `t`) |
| `IN-PROGRESS` | 作業中 (ショートカット: `i`、状態変更時にタイムスタンプ記録) |
| `DONE` | 完了 (ショートカット: `d`、タイムスタンプ記録) |
| `CANCELLED` | キャンセル (ショートカット: `c`、コメント入力) |

### org-mode バッファ内 — 見出し・構造操作

| キー | コマンド | 説明 |
|------|---------|------|
| `TAB` | `org-cycle` | 折り畳みトグル (Evil Normal) |
| `S-TAB` | `org-shifttab` | 全見出しの折り畳みレベルをトグル |
| `M-RET` | `org-insert-heading` | 同レベルの見出しを挿入 |
| `M-S-RET` | `org-insert-todo-heading` | TODO 見出しを挿入 |
| `M-<left>` / `M-<right>` | `org-promote-heading` / `org-demote-heading` | 見出しを昇格 / 降格 |
| `M-S-<left>` / `M-S-<right>` | `org-promote-subtree` / `org-demote-subtree` | サブツリーを昇格 / 降格 |
| `M-<up>` / `M-<down>` | `org-move-subtree-up` / `org-move-subtree-down` | サブツリーを上 / 下へ移動 |
| `C-c C-^` | `org-sort` | サブツリーを並び替え |
| `C-c *` | `org-ctrl-c-star` | 見出し/本文をトグル |
| `C-c C-c` | `org-ctrl-c-ctrl-c` | コンテキスト依存操作 (タグ設定・チェックボックストグル等) |

### org-mode バッファ内 — ナビゲーション

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c C-n` | `org-next-visible-heading` | 次の見出しへ |
| `C-c C-p` | `org-previous-visible-heading` | 前の見出しへ |
| `C-c C-f` | `org-forward-heading-same-level` | 同レベルの次の見出しへ |
| `C-c C-b` | `org-backward-heading-same-level` | 同レベルの前の見出しへ |
| `C-c C-u` | `outline-up-heading` | 親見出しへ |
| `gh` | `outline-up-heading` | 親見出しへ (Evil Normal) |
| `gj` | `org-forward-heading-same-level` | 同レベルの次の見出しへ (Evil Normal) |
| `gk` | `org-backward-heading-same-level` | 同レベルの前の見出しへ (Evil Normal) |
| `gl` | `outline-next-heading` | 次の見出しへ (Evil Normal) |
| `M-h` | `previous-multiframe-window` | 前のウィンドウへ (org-mode-map) |
| `M-l` | `next-multiframe-window` | 次のウィンドウへ (org-mode-map) |
| `C-x n s` | `org-narrow-to-subtree` | サブツリーにナロウ |
| `C-x n w` | `widen` | ナロウを解除 |

### org-mode バッファ内 — TODO / スケジュール (Evil Normal)

| キー | コマンド | 説明 |
|------|---------|------|
| `t` | `org-todo` | TODO ステートをトグル |
| `T` | `org-set-tags-command` | タグを設定 |
| `>` | `org-deadline` | 締め切り日を設定 |
| `<` | `org-schedule` | 予定日を設定 |
| `C-c C-t` | `org-todo` | TODO ステートをトグル (標準) |
| `C-c C-s` | `org-schedule` | 予定日を設定 (標準) |
| `C-c C-d` | `org-deadline` | 締め切り日を設定 (標準) |
| `C-c C-w` | `org-refile` | 別の見出しへリファイル |
| `S-<right>` / `S-<left>` | — | TODO ステートを次/前へ |
| `S-<up>` / `S-<down>` | — | 優先度を上げる / 下げる |

### org-mode バッファ内 — クロック (時間計測)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c C-x C-i` | `org-clock-in` | クロックイン (作業開始) |
| `C-c C-x C-o` | `org-clock-out` | クロックアウト (作業終了) |
| `C-c C-x C-q` | `org-clock-cancel` | クロックをキャンセル |
| `C-c C-x C-j` | `org-clock-goto` | 現在クロック中のタスクへジャンプ |
| `C-c C-x C-d` | `org-clock-display` | バッファ内の合計時間を表示 |
| `C-c C-x C-r` | `org-clock-report` | クロックレポートを挿入 |
| `C-c C-x C-e` | `org-clock-modify-effort-estimate` | 見積時間を変更 |
| `C-c C-x C-x` | `org-clock-in-last` | 直前のタスクを再クロックイン |

### org-mode バッファ内 — リンク・エクスポート

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c C-l` | `org-insert-link` | リンクを挿入 |
| `C-c C-o` | `org-open-at-point` | リンクを開く |
| `RET` | `org-open-at-point` | リンクを開く (Evil Normal) |
| `C-c C-x C-n` | `org-next-link` | 次のリンクへ |
| `C-c C-x C-p` | `org-previous-link` | 前のリンクへ |
| `C-c C-e` | `org-export-dispatch` | エクスポートメニューを開く |

### org-mode バッファ内 — アーカイブ・プロパティ

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c C-x C-a` | `org-archive-subtree-default` | アーカイブ (`~/org/archive.org` へ) |
| `C-c $` | `org-archive-subtree` | アーカイブ先を指定して実行 |
| `C-c C-x p` | `org-set-property` | プロパティを設定 |
| `C-c C-x e` | `org-set-effort` | 見積時間を設定 |
| `C-c C-x C-c` | `org-columns` | カラムビューを表示 |
| `C-c #` | `org-update-statistics-cookies` | 統計クッキーを更新 (チェックリスト等) |

### 画像の貼り付け (org-download)

`org-download` により、クリップボードやドラッグ&ドロップで画像を org ファイルに挿入できる。画像は org ファイルと同じディレクトリの `images/` サブディレクトリに自動保存される。

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c i p` | `org-download-clipboard` | クリップボードの画像を貼り付け |
| `C-c i s` | `org-download-screenshot` | スクリーンショットを撮って貼り付け |

**クリップボードから貼り付ける手順:**

1. スクリーンショット (`Cmd+Shift+4` 等) またはブラウザ上の画像をコピー
2. org ファイルで貼り付けたい位置にカーソルを移動
3. `C-c i p` で `org-download-clipboard` を実行
4. `images/20240101-123456_image.png` のようなファイルが自動保存され、`[[file:images/...]]` リンクが挿入される
5. インライン画像として自動表示される

> **Note:** macOS では `pngpaste` コマンドを使用。`brew install pngpaste` が必要（Brewfile に追加済み）。

### org GitHub 同期

`~/org` は `https://github.com/AtsushiKitano/Jurnal` で管理されており、自動同期される。

| トリガー | 説明 |
|---------|------|
| org ファイル保存の 5 秒後 | Emacs の `after-save-hook` でデバウンス実行 |
| 30 分ごと | launchd `com.user.org-sync` による定期実行 |
| `C-c o s` | 手動実行 |

同期スクリプト: `~/.conf/scripts/org-sync.sh` (git add → commit → pull --rebase → push)  
ログ: `~/.local/log/org-sync.log`

### Org Babel (コードブロック評価)

Org ファイル内のソースコードブロックを `C-c C-c` で評価し、結果をバッファに表示する。

**対応言語:** `emacs-lisp` / `python` / `shell` / `latex`

#### 基本操作

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c C-c` | `org-babel-execute-src-block` | カーソル位置のブロックを評価 |
| `C-c C-v C-b` | `org-babel-execute-buffer` | バッファ内の全ブロックを評価 |
| `C-c C-v C-s` | `org-babel-execute-subtree` | サブツリー内の全ブロックを評価 |
| `C-c C-v C-e` | `org-babel-execute-maybe` | ブロックを評価またはスキップ |
| `C-c C-v C-k` | `org-babel-remove-result` | 直下の評価結果を削除 |
| `C-c C-v C-t` | `org-babel-tangle` | ブロックをファイルへ書き出し (tangle) |
| `C-c C-v C-z` | `org-babel-switch-to-session` | セッションバッファへ切り替え |
| `C-c C-v C-i` | `org-babel-view-src-block-info` | ブロックのヘッダ情報を表示 |
| `C-c '` | `org-edit-special` | ブロックを専用バッファで編集 |

#### ブロックの書き方

```org
#+begin_src <言語> <ヘッダ引数...>
コード
#+end_src
```

**主要ヘッダ引数:**

| 引数 | 説明 | 例 |
|------|------|-----|
| `:results output` | 標準出力を結果として表示 | デフォルト |
| `:results value` | 最終式の戻り値を表示 | |
| `:results silent` | 結果を表示しない | |
| `:results file` | ファイルパスを画像として表示 | グラフ表示に使用 |
| `:file <name>` | 出力ファイル名を指定 | `:file myplot.png` |
| `:session <name>` | セッション名 (変数を引き継ぐ) | `:session *py*` |
| `:exports both` | コードと結果を両方エクスポート | |
| `:exports none` | エクスポートに含めない | |
| `:tangle <file>` | tangle 先ファイルを指定 | `:tangle script.py` |
| `:noweb yes` | noweb 参照を展開する | |

**使用例:**

```org
#+begin_src python :results output
print("Hello, Org Babel!")
#+end_src

#+RESULTS:
: Hello, Org Babel!
```

```org
#+begin_src shell
echo $(date)
#+end_src
```

```org
#+begin_src emacs-lisp
(+ 1 2 3)
#+end_src

#+RESULTS:
: 6
```

#### matplotlib グラフの表示

`C-c C-c` で評価すると `#+RESULTS:` にファイルリンクが挿入され、インライン画像として表示される。

```org
#+begin_src python :results output file graphics :file myplot.png
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 2 * np.pi, 100)
plt.figure(figsize=(6, 4))
plt.plot(x, np.sin(x), label="sin(x)")
plt.plot(x, np.cos(x), label="cos(x)")
plt.legend()
plt.tight_layout()
#+end_src
```

> **Note1:** `:results output file graphics :file <ファイル名>` を使う（`output` `file` `graphics` の 3 つすべて必要）。
> - `output` — stdout を結果として取得
> - `file` — ob-core が `:file` パラメータを見てリンク `[[file:...]]` を生成
> - `graphics` — ファイルを上書きせず、ob-python が `matplotlib.pyplot.savefig(絶対パス)` を自動追記

> **Note2:** `plt.savefig()` と `plt.close()` は**書かない**。`plt.close()` を書くと図が閉じられた後に ob-python が保存しようとして空ファイルになる。

> **Note3:** `file` を省略して `:results output graphics` にすると ob-core が `:file` パラメータを無視して `[[file:...]]` リンクを生成しないため RESULTS が空になる。

> **Note4:** `matplotlib.use('Agg')` は init.el の prologue で自動適用済みのため、個別ブロックでの設定は不要。

**ファイル全体でセッションを共有する場合:**

```org
#+PROPERTY: header-args:python :session *py* :exports both
```

ファイル先頭にこの行を追加すると、全ブロックで変数・インポートが引き継がれる。

**画像の再表示:** `C-c C-x C-v` (`org-toggle-inline-images`) または評価後に自動更新される。

#### LaTeX 数式プレビュー

org ファイル内の LaTeX 数式をインライン画像として表示する。`basictex` + `imagemagick` + `ghostscript` が必要。

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c C-x C-l` | `org-latex-preview` | カーソル付近の数式をプレビュートグル |
| `C-c C-x C-v` | `org-toggle-inline-images` | インライン画像の表示/非表示トグル |

**自動プレビュー（推奨）:** ファイル先頭に以下を追加すると開いたとき自動レンダリングされる。

```org
#+STARTUP: inlineimages latexpreview
```

**インライン数式:** コードブロック不要、直接書いて `C-c C-x C-l` でプレビュー。

```org
Einstein の式: $E = mc^2$

二項定理: $\binom{n}{k} = \frac{n!}{k!(n-k)!}$
```

**ディスプレイ数式（Emacs のみ）:**

```org
\begin{equation}
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
\end{equation}
```

**ディスプレイ数式（Emacs + GitHub 両対応）:**

```org
$$\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$$
```

**必要なツール:**

| ツール | 役割 | インストール |
|--------|------|------------|
| `basictex` | pdflatex を提供 | `brew install --cask basictex` |
| `imagemagick` | PDF → PNG 変換 | `brew install imagemagick` (Brewfile 済) |
| `ghostscript` | imagemagick の PDF 処理バックエンド | `brew install ghostscript` (Brewfile 済) |
| `dvipng` (任意) | 高速プレビュー。あれば自動で優先使用 | `sudo /Library/TeX/texbin/tlmgr install dvipng` |

> **Note:** `dvipng` が未インストールの場合は自動的に `imagemagick` で代替する。`imagemagick` は `ghostscript` が必要。どちらも Brewfile に追加済みのため新規 Mac では `brew bundle` で自動インストールされる。

### LaTeX 数式文法

org-mode では LaTeX の数式記法をそのまま使える。`C-c C-x C-l` でプレビュー。

#### 数式の区切り記号

| 記法 | 種類 | 推奨 |
|------|------|------|
| `$...$` | インライン（文中） | ✅ Emacs + GitHub |
| `\(...\)` | インライン（文中） | ✅ Emacs + GitHub |
| `$$...$$` | ディスプレイ（独立行） | ✅ Emacs + GitHub |
| `\[...\]` | ディスプレイ（独立行） | ✅ Emacs + GitHub |
| `\begin{equation}...\end{equation}` | ディスプレイ（番号付き） | Emacs のみ |
| `\begin{align}...\end{align}` | 複数行揃え | Emacs のみ |

**書き方例:**
```org
文中にインライン: $E = mc^2$ と書く。

ディスプレイ（両環境対応）:
$$\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$$
```

#### 上付き・下付き・分数・根号

| 記法 | 意味 | 例 |
|------|------|----|
| `^{...}` | 上付き (指数) | `$x^{2}$` → $x^2$ |
| `_{...}` | 下付き (添字) | `$x_{i}$` → $x_i$ |
| `\frac{分子}{分母}` | 分数 | `$\frac{a}{b}$` |
| `\sqrt{...}` | 平方根 | `$\sqrt{x}$` |
| `\sqrt[n]{...}` | n 乗根 | `$\sqrt[3]{x}$` |
| `\binom{n}{k}` | 二項係数 | `$\binom{n}{k}$` |

#### ギリシャ文字

| 記法 | 文字 | 記法 | 文字 |
|------|------|------|------|
| `\alpha` | α | `\Alpha` | Α |
| `\beta` | β | `\Beta` | Β |
| `\gamma` | γ | `\Gamma` | Γ |
| `\delta` | δ | `\Delta` | Δ |
| `\epsilon` / `\varepsilon` | ε | `\Epsilon` | Ε |
| `\theta` / `\vartheta` | θ | `\Theta` | Θ |
| `\lambda` | λ | `\Lambda` | Λ |
| `\mu` | μ | `\pi` | π |
| `\sigma` / `\varsigma` | σ | `\Sigma` | Σ |
| `\phi` / `\varphi` | φ | `\Phi` | Φ |
| `\omega` | ω | `\Omega` | Ω |
| `\rho` | ρ | `\tau` | τ |
| `\xi` | ξ | `\eta` | η |
| `\zeta` | ζ | `\chi` | χ |

#### 演算子・関数

| 記法 | 意味 | 記法 | 意味 |
|------|------|------|------|
| `\sum_{i=1}^{n}` | Σ (総和) | `\prod_{i=1}^{n}` | Π (総積) |
| `\int_{a}^{b}` | ∫ (積分) | `\iint` | ∬ (二重積分) |
| `\oint` | ∮ (周回積分) | `\lim_{x \to \infty}` | 極限 |
| `\sin`, `\cos`, `\tan` | 三角関数 | `\log`, `\ln`, `\exp` | 対数・指数 |
| `\max`, `\min` | 最大・最小 | `\sup`, `\inf` | 上限・下限 |
| `\partial` | ∂ (偏微分) | `\nabla` | ∇ (ナブラ) |
| `\pm` | ± | `\mp` | ∓ |
| `\times` | × | `\div` | ÷ |
| `\cdot` | ⋅ (中点) | `\circ` | ∘ (合成) |

#### 関係記号・矢印

| 記法 | 記号 | 記法 | 記号 |
|------|------|------|------|
| `\leq` | ≤ | `\geq` | ≥ |
| `\neq` | ≠ | `\approx` | ≈ |
| `\equiv` | ≡ | `\sim` | ∼ |
| `\in` | ∈ | `\notin` | ∉ |
| `\subset` | ⊂ | `\subseteq` | ⊆ |
| `\cup` | ∪ | `\cap` | ∩ |
| `\to` / `\rightarrow` | → | `\leftarrow` | ← |
| `\Rightarrow` | ⇒ | `\Leftarrow` | ⇐ |
| `\Leftrightarrow` | ⟺ | `\iff` | ⟺ |
| `\forall` | ∀ | `\exists` | ∃ |
| `\infty` | ∞ | `\emptyset` | ∅ |

#### 括弧・デリミタ

| 記法 | 説明 |
|------|------|
| `\left( ... \right)` | 自動サイズの丸括弧 |
| `\left[ ... \right]` | 自動サイズの角括弧 |
| `\left\{ ... \right\}` | 自動サイズの波括弧 |
| `\left\| ... \right\|` | 自動サイズのノルム |
| `\left\lfloor ... \right\rfloor` | 床関数 |
| `\left\lceil ... \right\rceil` | 天井関数 |

#### 複数行・行列

**整列式（`\begin{aligned}` は Emacs のみ）:**
```org
$$
\begin{aligned}
f(x) &= ax^2 + bx + c \\
     &= a\left(x + \frac{b}{2a}\right)^2 - \frac{b^2 - 4ac}{4a}
\end{aligned}
$$
```

**行列:**
```org
$$
A = \begin{pmatrix}
a_{11} & a_{12} \\
a_{21} & a_{22}
\end{pmatrix}
$$
```

行列環境の種類:

| 環境 | 括弧の種類 |
|------|-----------|
| `pmatrix` | 丸括弧 `(` `)` |
| `bmatrix` | 角括弧 `[` `]` |
| `vmatrix` | 縦棒 `\|` `\|`（行列式） |
| `Bmatrix` | 波括弧 `{` `}` |

#### よく使う数式例

```org
二次方程式の解: $x = \dfrac{-b \pm \sqrt{b^2 - 4ac}}{2a}$

Taylor 展開: $e^x = \sum_{n=0}^{\infty} \frac{x^n}{n!}$

正規分布: $f(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{-\frac{(x-\mu)^2}{2\sigma^2}}$

ベクトルの内積: $\mathbf{a} \cdot \mathbf{b} = \sum_{i=1}^{n} a_i b_i$

偏微分方程式: $\frac{\partial u}{\partial t} = \alpha \frac{\partial^2 u}{\partial x^2}$
```

#### 文字スタイル

| 記法 | スタイル | 用途 |
|------|---------|------|
| `\mathbf{A}` | **A**（太字） | ベクトル・行列 |
| `\mathcal{L}` | 筆記体 | 集合・写像 |
| `\mathbb{R}` | 黒板太字 | 実数・複素数等の数体 |
| `\mathrm{d}` | 立体 | 微分記号 |
| `\text{文字}` | テキスト | 数式中の文字 |
| `\hat{x}` | x̂（ハット） | 推定量 |
| `\bar{x}` | x̄（バー） | 平均 |
| `\vec{v}` | v⃗（矢印） | ベクトル |
| `\dot{x}` | ẋ（ドット） | 時間微分 |
| `\tilde{x}` | x̃（チルダ） | 近似値 |

### GitHub との互換表示

org ファイルを GitHub リポジトリで管理する場合、GitHub は `org-ruby` を使って org ファイルを HTML にレンダリングする。Emacs と GitHub の両方で正しく表示するには記法の選択が重要。

#### 数式記法の対応

| 記法 | Emacs | GitHub | 推奨 |
|------|-------|--------|------|
| `$...$` | ✅ インライン数式 | ✅ インライン数式 | ✅ 両対応 |
| `$$...$$` | ✅ ブロック数式 | ✅ ブロック数式 | ✅ 両対応 |
| `\(...\)` | ✅ | ✅ | ✅ 両対応 |
| `\[...\]` | ✅ | ✅ | ✅ 両対応 |
| `\begin{equation}...\end{equation}` | ✅ | ❌ 未対応（生テキスト表示） | ❌ Emacs 専用 |

**数式の書き方（推奨）:**

```org
インライン: $E = mc^2$

ブロック:
$$\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$$
```

#### 画像の対応

| 記法 | Emacs | GitHub | 推奨 |
|------|-------|--------|------|
| `[[file:image.png]]`（standalone） | ✅ インライン画像 | ✅ インライン画像 | ✅ 両対応 |
| `#+RESULTS:` 内の `[[file:...]]` | ✅ org-babel 結果 | ❌ `#+RESULTS:` ブロックごと非表示 | ❌ Emacs 専用 |

**matplotlib グラフを両方で表示する方法:**

`#+RESULTS:` に加えて、コードブロックの外に standalone リンクを追加する。

```org
#+begin_src python :results output file graphics :file myplot.png
import matplotlib.pyplot as plt
...
#+end_src

#+RESULTS:
[[file:myplot.png]]

[[file:myplot.png]]
```

- Emacs: `#+RESULTS:` の `[[file:...]]` と standalone リンクの両方でインライン表示（画像が2つ表示される）
- GitHub: `#+RESULTS:` ブロックは非表示。standalone `[[file:myplot.png]]` だけが `<img>` タグとして表示される

> **Note:** GitHub での表示のために画像ファイル（PNG 等）を git commit する必要がある。

#### `#+RESULTS:` ブロックの扱い

org-ruby は `#+RESULTS:` ブロックを HTML にレンダリングしない（非表示）。コードブロックの実行結果（テキスト出力）を GitHub で見せたい場合は `:exports both` を使い org-export で HTML/Markdown に変換するか、結果を直接 org 本文に記述する。

| 要素 | Emacs | GitHub |
|------|-------|--------|
| コードブロック (`#+begin_src`) | 構文ハイライト + 実行可能 | 構文ハイライトのみ（実行されない） |
| `#+RESULTS:` ブロック | 評価結果を表示 | 非表示 |
| standalone `[[file:...]]` | インライン画像 | インライン画像 |
| `$...$`, `$$...$$` | org-latex-preview で画像化 | MathJax でレンダリング |

### アジェンダビュー内のキー (`C-c a` 後)

| キー | 説明 |
|------|------|
| `a` | デイビュー |
| `w` | ウィークビュー |
| `m` | マンスビュー |
| `f` / `b` | 次の期間 / 前の期間 |
| `.` | 今日へ戻る |
| `j` | 日付を指定してジャンプ |
| `r` / `g` | アジェンダを更新 |
| `t` | TODO ステートを変更 |
| `s` | 全 org バッファを保存 |
| `l` | ログモードのトグル (完了タスクを表示) |
| `v` | ビュー切り替えメニュー |
| `C-c C-s` | 予定日を設定 |
| `C-c C-d` | 締め切り日を設定 |
| `C-c C-w` | リファイル |
| `C-c C-t` | TODO ステートを変更 |
| `I` | クロックイン |
| `O` | クロックアウト |
| `q` | アジェンダを閉じる |
| `RET` | 対象エントリのバッファへジャンプ |
| `TAB` | 対象エントリを別ウィンドウで表示 |

---

## ナビゲーション

### avy (文字ジャンプ)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-:` | `avy-goto-char-timer` | 文字を入力してジャンプ先を選択 |
| `C-*` | `avy-resume` | 直前の avy 操作を再開 |
| `M-g M-g` | `avy-goto-line` | 行番号指定でジャンプ |
| `[remap zap-to-char]` | `avy-zap-to-char` | 指定文字まで削除 |

### ace-window (ウィンドウ移動)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-x o` | `ace-window` | ウィンドウを選んで移動 (ラベル: a s d f g h i j k l) |

### winum (ウィンドウ番号移動)

| キー | コマンド | 説明 |
|------|---------|------|
| `M-1` ~ `M-9` | `winum-select-window-N` | 番号でウィンドウを直接選択 |

### xref (定義ジャンプ)

| キー | コマンド | 説明 |
|------|---------|------|
| `M-.` | `xref-find-definitions` | 定義へジャンプ |
| `M-?` | `xref-find-references` | 参照を一覧表示 |
| `M-,` | `xref-go-back` | ジャンプ前の位置へ戻る |
| `gd` | `xref-find-definitions` | 定義へジャンプ (Evil Normal) |
| `gr` | `xref-find-references` | 参照を一覧表示 (Evil Normal) |
| `C-t` | `xref-go-back` | 前の位置へ戻る (Evil Normal) |

バックエンド優先順位: eglot (LSP) → dumb-jump (ripgrep)

---

## 補完

### vertico (ミニバッファ補完)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-z` | `vertico-insert` | 候補を補完・挿入 |
| `C-l` | `grugrut/up-dir` | ひとつ上のディレクトリへ移動 |

### consult (検索・ナビゲーション)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-;` | `consult-buffer` | バッファ・ファイル・履歴を横断検索 |
| `[remap switch-to-buffer]` | `consult-buffer` | バッファ切り替え |
| `[remap goto-line]` | `consult-goto-line` | 行番号ジャンプ |
| `[remap yank-pop]` | `consult-yank-pop` | キルリング選択ペースト |

### corfu (インライン補完)

| キー | コマンド | 説明 |
|------|---------|------|
| `TAB` / `RET` | `corfu-insert` | 候補を確定して挿入 |

### isearch

| キー | コマンド | 説明 |
|------|---------|------|
| `C-n` | `isearch-repeat-forward` | 次のヒットへ |
| `C-b` | `isearch-repeat-backward` | 前のヒットへ |
| `C-y` | `isearch-yank-kill` | kill-ring からペースト |
| `s-v` | `my/isearch-yank-clipboard` | システムクリップボードからペースト |

---

## 編集

### expand-region (選択範囲拡大)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-.` | `er/expand-region` | 選択範囲を意味単位で拡大 |

### vundo (Undo ツリー)

| キー | コマンド | 説明 |
|------|---------|------|
| `M-x vundo` | `vundo` | undo 履歴をツリー表示 (vundo バッファ内は `q` で閉じる) |

### yasnippet (スニペット操作)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c y i` | `yas-insert-snippet` | スニペットを挿入 |
| `C-c y n` | `yas-new-snippet` | 新しいスニペットを作成 |
| `C-c y v` | `yas-visit-snippet-file` | スニペットファイルを開く |
| `C-c y l` | `yas-describe-tables` | スニペット一覧を表示 |
| `C-c y g` | `yas-reload-all` | スニペットをリロード |

スニペットの展開: キーワードを入力して `TAB`

---

## yasnippet スニペット一覧

### Go (`go-mode` / `go-ts-mode`)

| キー | 展開内容 |
|------|---------|
| `func` | func 定義 |
| `mthd` | メソッド定義 |
| `main` | func main() |
| `init` | func init() |
| `if` | if 文 |
| `iferr` | if err != nil { ... } |
| `err` | error 型変数 |
| `el` | else 節 |
| `for` | for 文 |
| `range` | for range 文 |
| `sw` | switch 文 |
| `sel` | select 文 |
| `def` | default 節 |
| `map` | map 型 |
| `var` | var 宣言 |
| `const` | const 宣言 |
| `imp` | import 文 |
| `type` | type 定義 |
| `lambda` | 無名関数 |
| `pr` | fmt.Printf(...) |
| `dd` | fmt.Printf("%+v\n", ...) (デバッグ用) |
| `at` | テスト関数 |
| `bench` | ベンチマーク関数 |
| `parbench` | 並列ベンチマーク |
| `example` | Example 関数 |
| `testmain` | TestMain 関数 |

### JavaScript (`js-mode`) ※ TypeScript も同スニペット利用

| キー | 展開内容 |
|------|---------|
| `imp` | import 文 |
| `imd` | import { ... } from |
| `ime` | import * as |
| `imn` | import (モジュール名なし) |
| `ima` | import ... as |
| `exp` | export default |
| `edf` | export default function |
| `enf` | export named function |
| `exd` | export { ... } |
| `exa` | export ... as |
| `const` | const 宣言 |
| `let` | let 宣言 |
| `f` | function 定義 |
| `nfn` | 名前付きアロー関数 |
| `anfn` | 無名アロー関数 |
| `class` | class 定義 |
| `init` | constructor |
| `met` | メソッド |
| `metb` | bound メソッド |
| `prom` | Promise |
| `sw` | switch 文 |
| `for` | for 文 |
| `fof` | for...of |
| `fin` | for...in |
| `fre` | forEach |
| `try` | try...catch |
| `clg` | console.log |
| `clo` | console.log (フォーマット付き) |
| `cer` | console.error |
| `cwa` | console.warn |
| `cin` | console.info |
| `cdi` | console.dir |
| `cta` | console.table |
| `cas` | console.assert |
| `cgr` / `cge` | console.group / groupEnd |
| `cte` | console.timeEnd |
| `sto` | setTimeout |
| `sti` | setInterval |
| `dbg` | debugger |
| `/**` | JSDoc コメント (複数行) |

### Python (`python-mode` / `python-ts-mode`)

| キー | 展開内容 |
|------|---------|
| `def` | def メソッド(self, ...) |
| `f` | 関数定義 |
| `cls` | class 定義 |
| `scls` | サブクラス定義 |
| `dc` | @dataclass クラス |
| `if` | if 文 |
| `ife` | if/else 文 |
| `for` | for ループ |
| `wh` | while ループ |
| `with` | with 文 |
| `wo` | with open(...) |
| `try` | try/except |
| `tryelse` | try/except/else |
| `lam` | lambda 式 |
| `imp` | import 文 |
| `from` | from ... import |
| `main` | if __name__ == '__main__' |
| `ifm` | ifmain |
| `p` | print(...) |
| `r` | return 文 |
| `ps` | pass |
| `cm` | @classmethod |
| `sm` | @staticmethod |
| `d` | docstring |
| `fd` | 関数 docstring |
| `id` | __init__ docstring |
| `md` | メソッド docstring |
| `_init` | \_\_init\_\_ |
| `_repr` | \_\_repr\_\_ |
| `_str` | \_\_str\_\_ |
| `_call` | \_\_call\_\_ |
| `_enter` / `_exit` | \_\_enter\_\_ / \_\_exit\_\_ |
| `_iter` / `_next` | \_\_iter\_\_ / \_\_next\_\_ |
| `pdb` | pdb.set_trace() |
| `ipdb` | ipdb.set_trace() |
| `ae` / `ane` | assertEqual / assertNotEqual |
| `at` / `af` | assertTrue / assertFalse |
| `ai` / `an` | assertIn / assertNotIn |
| `ar` | assertRaises |
| `tcs` | テストクラス |
| `uv` | uv script ヘッダ |
| `utf8` | # -*- coding: utf-8 -*- |
| `env` | #!/usr/bin/env python |

### Terraform (`terraform-mode`)

| キー | 展開内容 |
|------|---------|
| `res` | resource ブロック |
| `mod` | module ブロック |
| `var` | variable ブロック |
| `output` | output ブロック |
| `prov` | provider ブロック |
| `data` | data ブロック |
| `locals` | locals ブロック |
| `import` | import ブロック |
| `tf` | terraform ブロック |
| `goog_project` | google_project リソース |
| `goog_project_iam_member` | google_project_iam_member |
| `goog_service_account` | google_service_account |
| `goog_storage_bucket` | google_storage_bucket |
| `goog_container_cluster` | google_container_cluster |
| `goog_compute_instance` | google_compute_instance |
| `goog_pubsub_topic` | google_pubsub_topic |
| `goog_kms_key_ring` | google_kms_key_ring |

※ `goog_` プレフィックスで多数の GCP リソーススニペットあり。`C-c y i` で検索可。

### Org-mode (`org-mode`)

| キー | 展開内容 |
|------|---------|
| `<src` | #+begin_src ... #+end_src |
| `<e` | #+begin_example ... #+end_example |
| `<q` | #+begin_quote ... #+end_quote |
| `<c` | #+begin_center ... #+end_center |
| `<v` | #+begin_verse ... #+end_verse |
| `<ex` | #+begin_export ... #+end_export |
| `<ht` | #+begin_html ... #+end_html |
| `<i` | #+include: |
| `<ti` | #+title: |
| `<au` | #+author: |
| `<da` | #+date: |
| `<em` | #+email: |
| `<ke` | #+keywords: |
| `<op` | #+options: |
| `<li` | [[link]] |
| `<im` | [[image]] |
| `<ta` | テーブル |
| `py_` | python src ブロック |
| `emacs-lisp_` | emacs-lisp src ブロック |
| `elisp_` | elisp src ブロック |
| `dot_` | dot (Graphviz) src ブロック |
| `uml` | PlantUML src ブロック |
| `set` | #+setupfile: |
| `uuid_` | UUID 生成 |
| `entry_` | org entry テンプレート |
| `fig_` | figure リンク |

### Emacs Lisp (`emacs-lisp-mode`)

| キー | 展開内容 |
|------|---------|
| `def` | defun 関数定義 |
| `lam` | lambda |
| `let` | let 束縛 |
| `setq` | setq |
| `defvar` | defvar |
| `const` | defconst |
| `defcustom` | defcustom |
| `add-hook` | add-hook |
| `define-key` | define-key |
| `global-set-key` | global-set-key |
| `cond` | cond 式 |
| `w` | when |
| `minor` | マイナーモード定義 |
| `header` | パッケージヘッダ |
| `up` | use-package |
| `upb` | use-package (バインド付き) |
| `edt` | ert-deftest |
| `f` | format |
| `message` | message |
| `save-excursion` | save-excursion |
| `with-current-buffer` | with-current-buffer |
| `interactive` | (interactive) |
| `grabthing` | カーソル下の単語を取得 |

### Markdown (`markdown-mode` / `gfm-mode`)

| キー | 展開内容 |
|------|---------|
| `h1` ~ `h6` | 見出し (# / = / -- 記法) |
| `` ` `` | インラインコード |
| `code` | コードブロック |
| `_` | イタリック |
| `__` | 太字 |
| `highlight` | ハイライト |
| `-` | 箇条書き (-) |
| `+` | 箇条書き (+) |
| `ol` | 番号付きリスト |
| `link` | `[text](url)` リンク |
| `img` | `![alt](url)` 画像 |
| `rlink` | 参照リンク |
| `rimg` | 参照画像 |
| `rlb` | 参照ラベル定義 |
| `hr` | 水平線 (- / * 記法) |
| `utf8` | UTF-8 encoding コメント |

### Shell Script (`sh-mode`)

| キー | 展開内容 |
|------|---------|
| `!` | #!/bin/bash |
| `s!` | より安全な bash 設定 (set -euo pipefail 等) |
| `f` | function 定義 |
| `if` | if 文 |
| `ife` | if/else 文 |
| `for` | for ループ |
| `while` | while ループ |
| `until` | until ループ |
| `case` | case 文 |
| `select` | select 文 |
| `args` | 引数処理 |
| `script-dir` | スクリプトのディレクトリを取得 |

---

## ターミナル (eat)

### モードの概要

eat には3つのモードがあり、コピー/ペーストはモードに応じて操作が異なる。

| モード | 説明 | 切り替え |
|--------|------|---------|
| **Emacs モード** | 起動直後のデフォルト。`buffer-read-only=t` で全 Emacs キーバインドが使える。テキストのコピーはこのモードで行う | `C-c C-e` (semi-char内) |
| **Semi-char モード** | ほとんどのキーはターミナルへ送信。`C-x` / `C-g` / `M-x` など一部の Emacs キーは Emacs 側で処理。ペーストは `C-y` | `C-c C-j` |
| **Char モード** | 全キーをターミナルへ送信。vi など full-screen アプリ向け | `C-c M-d` |

### コピー/ペーストのフロー

**テキストをコピーしてターミナルにペーストする手順:**

1. ターミナルに表示されているテキストをコピーする
   - **方法A (マウス):** マウスドラッグで選択 → 自動的に kill-ring に入る
   - **方法B (キーボード):** `C-c C-e` で Emacs モードへ切り替え → `C-SPC` でマーク → 移動して `M-w` でコピー → `C-c C-j` で semi-char モードへ戻る
2. ターミナルにペーストする
   - semi-char モードで `C-y` → `eat-yank` でターミナルへ送信

**Emacs の別バッファからターミナルへペーストする手順:**

1. 別バッファで `M-w` でコピー (kill-ring に入る)
2. eat バッファへ切り替え
3. semi-char モードで `C-y` → ターミナルへ貼り付け

### 起動・モード切り替え

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c t` | `eat` | ターミナルを起動 (グローバル) |
| `C-c C-j` | `eat-semi-char-mode` | Semi-char モードへ切り替え (カスタム) |
| `C-c M-d` | `eat-char-mode` | Char モードへ切り替え |
| `C-c C-e` | `eat-emacs-mode` | Emacs モードへ切り替え (semi-char 内) |
| `C-M-m` | `eat-semi-char-mode` | Char モード → Semi-char モードへ |
| `C-c C-l` | `eat-line-mode` | Line モードへ切り替え |

### コピー操作 (Emacs モード)

Emacs モードは `buffer-read-only=t` なのでキーボードで cut はできないが、コピーは通常通り動く。

| キー | コマンド | 説明 |
|------|---------|------|
| マウスドラッグ | — | 選択範囲を kill-ring に自動コピー |
| `C-SPC` | `set-mark-command` | マークをセット (範囲選択の開始) |
| `M-w` | `kill-ring-save` | 選択範囲をコピー |
| `C-g` | — | 選択を解除してノーマルに戻る |

### ペースト操作 (Semi-char モード)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-y` | `eat-yank` | kill-ring の先頭をターミナルへ貼り付け |
| `M-y` | `eat-yank-from-kill-ring` | kill-ring を選んで貼り付け (Emacs 28+) |
| `S-insert` | `eat-yank` | `C-y` と同じ |

### その他の操作 (Semi-char モード)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-q` | `eat-quoted-input` | 次に押したキーをそのままターミナルへ送信 |
| `C-c C-c` | `eat-self-input` | `C-c` をターミナルへ送信 (SIGINT 相当) |

### ナビゲーション (全モード共通 / カスタム)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c C-p` | `eat-previous-shell-prompt` | 前のシェルプロンプトへジャンプ |
| `C-c C-n` | `eat-next-shell-prompt` | 次のシェルプロンプトへジャンプ |
| `C-x n d` | `eat-narrow-to-shell-prompt` | 現在のプロンプト出力にナロウ |
| `C-c C-k` | `eat-kill-process` | ターミナルプロセスを終了 |
| `C-h` | backspace 送信 | `\177` をターミナルへ送信 (カスタム) |
| `M-h` | `previous-multiframe-window` | 前のウィンドウへ (カスタム) |
| `M-l` | `next-multiframe-window` | 次のウィンドウへ (カスタム) |
| `M-z` | `my/toggle-zoom-window` | ウィンドウズームトグル (カスタム) |
| `C-x o` | `ace-window` | ace-window でウィンドウ移動 (カスタム) |

---

## Git (magit)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-x g` | `magit-status` | magit ステータスを開く |

---

## 日本語入力 (ddskk / AZIK)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-x C-j` | `skk-mode` | SKK モードをオン/オフ |
| `C-x j` | `skk-mode` | SKK モードをオン/オフ |
| `M-j` | `skk-mode` | SKK モードをオン/オフ |

---

## AI / LLM

### agent-shell (Claude Code)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c A` | `agent-shell` | Claude Code シェルを起動 |
| `C-c s` | `agent-shell-send-screenshot` | スクリーンショットを送信 (agent-shell-mode 内) |
| `C-c i` | `agent-shell-send-clipboard-image` | クリップボード画像を送信 (agent-shell-mode 内) |

### ellama (Gemini)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c e` | `ellama-transient-main-menu` | ellama メニューを開く |

---

## コミュニケーション (Slack)

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c s s` | `slack-start` | Slack を起動 |
| `C-c s c` | `slack-channel-select` | チャンネルを選択 |
| `C-c s m` | `slack-im-select` | ダイレクトメッセージを選択 |
| `C-c C-j` | `slack-message-write-another-buffer` | 別バッファでメッセージ入力 (slack-mode 内) |

---

## Markdown

| キー | コマンド | 説明 |
|------|---------|------|
| `C-c C-v` | `my/markdown-preview` | pandoc + shr でプレビュー表示 |
| `C-c C-x v` | `my/markdown-auto-preview-mode` | 保存時自動プレビュー更新のトグル |
