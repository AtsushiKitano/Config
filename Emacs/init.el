;;; init.el -*-config: utf-8 ; lexical-binding: t -*-

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
      		("melpa" . "https://melpa.org/packages/")
      		("org" . "https://orgmode.org/elpa/")
      		("nongnu" . "https://elpa.nongnu.org/nongnu/")))
  (package-initialize)
  (use-package leaf :ensure t)

(leaf leaf-keywords
  :ensure t
  :init
  (leaf blackout :ensure t)
  :config
  ;; optional パッケージ
  (leaf hydra :ensure t)
  (leaf el-get :ensure t)
  (leaf blackout :ensure t)

  ;; leaf-keywordsの初期化
  (leaf-keywords-init)))

(leaf leaf-convert
  :doc "Convert many format to leaf format"
  :ensure t)

(leaf gcmh
  :ensure t
  :global-minor-mode t
  :custom
  (gcmh-verbose . t))

;; mise (asdf-compatible version manager) のshimsパスをEmacsのPATHに追加
;; これにより terraform など mise 管理のツールを Emacs から利用できる
(let ((mise-shims (expand-file-name "~/.local/share/mise/shims")))
  (when (file-directory-p mise-shims)
    (add-to-list 'exec-path mise-shims)
    (setenv "PATH" (concat mise-shims ":" (getenv "PATH")))))

;; Homebrew (Apple Silicon) のバイナリパスを追加
;; claude-agent-acp など /opt/homebrew/bin にインストールされるツールのため
(let ((homebrew-bin "/opt/homebrew/bin"))
  (when (file-directory-p homebrew-bin)
    (add-to-list 'exec-path homebrew-bin)
    (setenv "PATH" (concat homebrew-bin ":" (getenv "PATH")))))

(leaf general-settings
  :config
  (prefer-coding-system 'utf-8-unix)
  (global-set-key [mouse-2] 'mouse-yank-at-click)
  (global-unset-key "\C-z")
  (delete-selection-mode t)
  (electric-pair-mode t)
  (define-key global-map (kbd "C-{") 'hs-hide-block)
  (define-key global-map (kbd "C-}") 'hs-show-block)
  (define-key global-map (kbd "<C-tab>") 'hs-toggle-hiding)
  (add-hook 'prog-mode-hook 'hs-minor-mode)
  (setq-default bidi-paragraph-direction 'left-to-right)
  (setq bidi-inhibit-bpa t)
  (define-key global-map (kbd "C-d") 'delete-forward-char)
  (define-key global-map (kbd "C-f") 'forward-char)
  (define-key global-map (kbd "C-k") 'kill-line)
  (define-key global-map (kbd "C-e") 'move-end-of-line)
  (define-key global-map [?¥] [?\\])
(prefer-coding-system 'utf-8-unix)

  :setq
  (read-answer-short . t)
  (create-lockfiles . nil)
  (history-length . 500)
  (history-delete-duplicates . t)
  (line-move-visual . nil)
  (mouse-drag-copy-region . t)
  (backup-inhibited . t)
  (require-final-newline . t)
  (auto-save-file-name-transforms . `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t))))
  :config
  (make-directory (expand-file-name "auto-save/" user-emacs-directory) t)

(leaf :font
  :config
  (leaf nerd-icons
	:ensure t)
  (defun my/setup-fonts (&optional frame)
	(let ((target-frame (or frame (selected-frame))))
	  (with-selected-frame target-frame
		(when (display-graphic-p)
		  (let* ((ascii-family "Monaspace Neon NF")
				 (jp-family "HackGen Console NF")
				 (ascii-spec (font-spec :family ascii-family :weight 'normal))
				 (jp-spec    (font-spec :family jp-family    :weight 'normal)))
			(set-face-attribute 'default target-frame :family ascii-family :height 180)
			(set-fontset-font nil 'ascii            ascii-spec target-frame 'append)
			(set-fontset-font nil 'japanese-jisx0208 jp-spec   target-frame 'append))))))
  (add-hook 'after-make-frame-functions #'my/setup-fonts)
  (when (display-graphic-p)
	(my/setup-fonts)))

(leaf all-the-icons
  :ensure t
  :init (leaf memoize :ensure t)
  :require t
)

(leaf doom-themes
  :ensure t
  :defun (doom-themes-visual-bell-config)
  :config
  (load-theme 'doom-vibrant t)
  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (doom-themes-org-config))

(leaf doom-modeline
  :ensure t
  :global-minor-mode t
  :custom
  (doom-modeline-bar-width . 4)
  (doom-modeline-hub . t)
  ;; evil state などのモーダルアイコンを nerd-icons (v3 PUA-A) ではなく
  ;; ASCII テキスト (<N>/<E>/<I> 等) で表示する。
  ;; Monaspace Neon NF / HackGen Console NF は Nerd Fonts v2 のため
  ;; U+F0xxx 台のグリフが文字化け (0F0/BF8 トーフボックス) になる。
  (doom-modeline-modal-icon . nil))

(defvar my/sysinfo-string "" "モードラインに表示するシステム情報文字列.")

(defun my/sysinfo--shell-command ()
  "システム情報を収集するシェルコマンドを返す."
  (concat
   ;; CPU: top の1サンプルから user+sys を合算 (変数に取り出して % を除去)
   "cpu=$(top -l 1 -n 0 -s 0 2>/dev/null"
   " | awk '/CPU usage/{u=$3; s=$5; gsub(/%/,\"\",u); gsub(/%/,\"\",s); printf \"%.0f\", u+s}');"
   ;; メモリ: vm_stat から (active+wired+compressor)/total を計算
   "mem=$(vm_stat 2>/dev/null"
   " | awk '/Pages free:/{f=int($3)} /Pages active:/{a=int($3)}"
   " /Pages inactive:/{i=int($3)} /Pages wired down:/{w=int($4)}"
   " /Pages occupied by compressor:/{c=int($5)}"
   " END{t=f+a+i+w+c; if(t>0) printf \"%.0f\",(a+w+c)*100/t; else print \"?\"}');"
   ;; ディスク: 使用量(使用率) のみ — 分母(総量)は表示しない
   "disk=$(df -H / 2>/dev/null | awk 'NR==2{printf \"%s(%s)\",$3,$5}');"
   "printf 'CPU:%s%% | MEM:%s%% | DSK:%s' \"${cpu:-?}\" \"${mem:-?}\" \"${disk:-?}\""))

(defun my/sysinfo-update ()
  "システム情報を非同期で更新する."
  (let* ((buf (generate-new-buffer " *my-sysinfo*"))
         (proc (start-process "my-sysinfo" buf
                              "/bin/bash" "-c"
                              (my/sysinfo--shell-command))))
    (set-process-sentinel
     proc
     (lambda (p _e)
       (when (zerop (process-exit-status p))
         (setq my/sysinfo-string
               ;; mode-line format では % が制御文字になるため %% にエスケープ
               (replace-regexp-in-string
                "%" "%%"
                (string-trim
                 (with-current-buffer (process-buffer p)
                   (buffer-string)))))
         (force-mode-line-update t))
       (when (buffer-live-p (process-buffer p))
         (kill-buffer (process-buffer p)))))))

;; 起動 1 秒後に初回実行、以降 10 秒ごとに更新
(run-with-timer 1 10 #'my/sysinfo-update)

(leaf shackle
  :ensure t
  :global-minor-mode t
  :custom
  (shackle-rules . '(("*Backtrace*" :popup t)
					 ("*Leaf Expand*" :popup t)
					 ("Shell Command Output*" :popup t))))

(leaf beacon
  :ensure t
  :config
  (when (display-graphic-p)
    (beacon-mode 1))
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (with-selected-frame frame
                (if (display-graphic-p)
                    (beacon-mode 1)
                  (beacon-mode -1))))))

(leaf volatile-highlights
  :ensure t
  :config
  (when (display-graphic-p)
    (volatile-highlights-mode 1))
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (with-selected-frame frame
                (when (display-graphic-p)
                  (volatile-highlights-mode 1))))))

(leaf anzu
  :ensure t
  :global-minor-mode global-anzu-mode
  :bind
  (("M-%" . anzu-query-replace)))

(leaf migemo
  :ensure t
  :require t
  :defun
  (migemo-init)
  :custom
  (migemo-command . "cmigemo")
  (migemo-options . '("-q" "--emacs"))
  (migemo-dictionary . "/opt/homebrew/share/migemo/utf-8/migemo-dict")
  (migemo-user-dictionary . nil)
  (migemo-regex-dictionary . nil)
  (migemo-coding-system . 'utf-8-unix)
  :config
  (migemo-init)
  (with-eval-after-load 'skk
    (setq skk-isearch-start-mode 'utf-8)))

(leaf agent-shell
  :ensure t
  :bind
  (("C-c A" . agent-shell)
   (:agent-shell-mode-map
    ("C-c s" . agent-shell-send-screenshot)
    ("C-c i" . agent-shell-send-clipboard-image)))
  :hook
  (agent-shell-mode-hook . (lambda ()
                             (when (fboundp 'evil-emacs-state)
                               (evil-emacs-state))
			     (display-line-numbers-mode -1)))
  :config
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t))
  (setq agent-shell-preferred-agent-config
        (agent-shell-anthropic-make-claude-code-config)))

(leaf evil
  :ensure t
  :custom
  (evil-want-integration . t)
  (evil-want-keybinding . nil)
  (evil-want-C-u-scroll . t)
  :config
  (evil-mode 1)
  (dolist (mode '(vterm-mode dired-mode magit-mode imenu-list-major-mode eat-mode agent-shell-mode neotree-mode))
    (evil-set-initial-state mode 'emacs)))

(leaf evil-collection
  :ensure t
  :after evil
  :custom
  (evil-collection-unimpaired-mode . nil)
  :config
  (evil-collection-init)
  (defun my/kill-region-or-backward-kill-word ()
    "リージョンが選択されていれば切り取り、そうでなければ単語を後退削除する。"
    (interactive)
    (if (use-region-p)
        (kill-region (region-beginning) (region-end))
      (backward-kill-word 1)))
  (defun my/kill-ring-save-region ()
    "リージョンまたは evil visual 選択範囲をコピーする。"
    (interactive)
    (cond
     ((and (bound-and-true-p evil-local-mode) (evil-visual-state-p))
      (let* ((range (evil-visual-range))
             (beg (nth 0 range))
             (end (nth 1 range)))
        (kill-ring-save beg end)
        (evil-normal-state)
        (message "Copied region")))
     ((use-region-p)
      (kill-ring-save (region-beginning) (region-end))
      (deactivate-mark)
      (message "Copied region"))
     (t
      (message "No region selected"))))
  ;; evil-collection 初期化後に insert モードの Emacs キーバインドを上書き
  (evil-define-key 'insert 'global (kbd "C-p") #'previous-line)
  (evil-define-key 'insert 'global (kbd "C-n") #'next-line)
  (evil-define-key 'insert 'global (kbd "C-b") #'backward-char)
  (evil-define-key 'insert 'global (kbd "C-f") #'forward-char)
  (evil-define-key 'insert 'global (kbd "C-a") #'move-beginning-of-line)
  (evil-define-key 'insert 'global (kbd "C-e") #'move-end-of-line)
  (evil-define-key 'insert 'global (kbd "M-f") #'forward-word)
  (evil-define-key 'insert 'global (kbd "M-b") #'backward-word)
  (evil-define-key 'insert 'global (kbd "C-d") #'delete-forward-char)
  (evil-define-key 'insert 'global (kbd "C-h") #'backward-delete-char)
  (evil-define-key 'insert 'global (kbd "C-k") #'kill-line)
  ;; C-w: リージョン切り取り / 単語後退削除 (insert・normal・motion・visual)
  (evil-define-key 'insert 'global (kbd "C-w") #'my/kill-region-or-backward-kill-word)
  (evil-define-key '(normal motion visual) 'global (kbd "C-w") #'my/kill-region-or-backward-kill-word)
  ;; M-w: リージョンコピー (insert・normal・motion・visual)
  (evil-define-key 'insert 'global (kbd "M-w") #'my/kill-ring-save-region)
  (evil-define-key '(normal motion visual) 'global (kbd "M-w") #'my/kill-ring-save-region)
  (evil-define-key 'insert 'global (kbd "C-y") #'yank)
  (evil-define-key 'insert 'global (kbd "M-d") #'kill-word)
  (evil-define-key 'insert 'global (kbd "C-g") #'evil-normal-state)
  ;; normal/motion モードでも C-n/C-p を evil-paste-pop-next から上書き
  (evil-define-key '(normal motion) 'global (kbd "C-n") #'next-line)
  (evil-define-key '(normal motion) 'global (kbd "C-p") #'previous-line)
  ;; ターミナルでは C-Space が C-@ (NUL) として届くため全ステートで set-mark-command に割り当て
  (evil-define-key '(normal insert motion visual) 'global (kbd "C-@") #'set-mark-command)
  (evil-define-key '(normal insert motion visual) 'global (kbd "C-SPC") #'set-mark-command)
  ;; C-TAB で括弧ブロックの折り畳みトグル
  (evil-define-key '(normal insert motion visual) 'global (kbd "<C-tab>") #'hs-toggle-hiding))

(defun my/isearch-yank-clipboard ()
  "システムクリップボードまたは kill-ring の内容を isearch に貼り付ける."
  (interactive)
  (isearch-yank-string
   (or (gui-get-selection 'CLIPBOARD 'UTF8_STRING)
       (current-kill 0 t))))

(leaf isearch
  :doc "isearch 中の次／前候補ナビゲーション"
  :bind
  (:isearch-mode-map
   ("C-n" . isearch-repeat-forward)
   ("C-b" . isearch-repeat-backward)
   ("C-y" . isearch-yank-kill)
   ("M-y" . isearch-yank-pop-only)
   ("s-v" . my/isearch-yank-clipboard))
  :config
  ;; Evil の emulation-mode-map-alists は minor-mode-map-alist より優先度が高いため、
  ;; :bind だけでは C-y が evil-scroll-line-up に奪われる。
  ;; evil-define-key で isearch-mode-map に登録することで Evil 経由でも確実に動作させる。
  (with-eval-after-load 'evil
    (evil-define-key '(normal emacs) isearch-mode-map
      (kbd "C-y") #'isearch-yank-kill
      (kbd "M-y") #'isearch-yank-pop-only)))

(defun my/neotree-toggle ()
  "Toggle neotree. VCS root があればそこを、なければ current directory を開く."
  (interactive)
  (require 'neotree)
  (if (neo-global--window-exists-p)
    (neotree-hide)
    (neotree-dir (or (vc-root-dir) default-directory))))

(leaf neotree
  :ensure t
  :bind
  (("C-c d" . my/neotree-toggle))
  :custom
  (neo-smart-open . t)
  (neo-window-width . 30)
  (neo-show-hidden-files . nil)
  (neo-autorefresh . t))

(leaf eat
  :ensure t
  :bind (("C-c t" . eat))
  :custom
  (eat-kill-buffer-on-exit . t)
  (eat-enable-mouse . t)

  :defun
  (ins-eat-skk-settings)
  (eat-reload-all-keymaps)

  :config
  (add-hook 'eat-mode-hook #'ins-eat-skk-settings)

  (with-eval-after-load 'eat
    (define-key eat-mode-map (kbd "C-h") (lambda ()
                                           (interactive)
                                           (eat-self-input 1 ?\177)))
    (define-key eat-mode-map "\eh" #'previous-multiframe-window)
    (define-key eat-mode-map "\el" #'next-multiframe-window)
    (define-key eat-mode-map (kbd "M-z") #'my/toggle-zoom-window)
    (define-key eat-mode-map (kbd "C-x o") #'ace-window)
    (define-key eat-semi-char-mode-map "\eh" #'previous-multiframe-window)
    (define-key eat-semi-char-mode-map "\el" #'next-multiframe-window)
    (define-key eat-mode-map (kbd "C-c C-j") #'eat-semi-char-mode))

  (with-eval-after-load 'evil
    (evil-set-initial-state 'eat-mode 'emacs))

  (defun ins-eat-skk-settings ()
    (when (fboundp 'evil-emacs-state)
      (evil-emacs-state)))

  :hook (eat-mode-hook . (lambda ()
                           (setq-local inhibit-read-only t)
                           (setq-local scroll-margin 0)
                           (display-line-numbers-mode -1)
                           (when (fboundp 'evil-emacs-state)
                                          (evil-emacs-state))
                           ))
  )

(leaf ddskk
  :ensure t
  :bind
  (("C-x C-j" . skk-mode)
   ("C-x j"   . skk-mode)
   ("M-j"     . skk-mode))
  :init
  (defvar dired-bind-jump nil) ; dired-xに `C-x C-j` が奪われてしまうので対処
  :custom
  (skk-use-azik                      . t) ; AZIKを使用
  (skk-azik-keyboard-type            . 'jp106)
  (skk-server-host                   . "localhost")
  (skk-server-portnum                . 1178)
  (skk-egg-like-newline              . t) ; 変換時にはリータンで改行しない
  (skk-japanese-message-and-error    . t)
  (skk-auto-insert-paren             . t)
  (skk-check-okurigata-on-touroku    . t)
  (skk-show-annotation               . t)
  (skk-annotation-show-wikipedia-url . t)
  (skk-show-tooltip                  . nil)
  (skk-isearch-start-mode            . 'latin)
  (skk-henkan-okuri-strictly         . nil)
  (skk-process-okuri-early           . nil)
  (skk-status-indicator              . 'minior-mode))

;; SKK 状態文字列を返すヘルパー (BUF で評価)
(defun my/skk-mode-string-in (buf)
  "BUF の SKK 状態文字列。SKK 無効時は nil."
  (with-current-buffer buf
    (cond
     ((not (bound-and-true-p skk-mode)) nil)
     ((bound-and-true-p skk-katakana)
      (propertize "[カナ]" 'face '(:foreground "#98be65" :weight bold)))
     ((bound-and-true-p skk-ascii-mode)
      (propertize "[英数]" 'face '(:foreground "#51afef" :weight bold)))
     (t
      (propertize "[かな]" 'face '(:foreground "#c678dd" :weight bold))))))

;; ① doom-modeline セグメントを定義し main modeline の右端に追加
(with-eval-after-load 'doom-modeline
  (doom-modeline-def-segment my/skk-indicator
    "SKK の入力状態."
    (my/skk-mode-string-in (current-buffer)))

  (doom-modeline-def-segment my/sysinfo-segment
    "CPU / メモリ / ディスク使用率."
    (when (and (doom-modeline--active)
               (not (string-empty-p my/sysinfo-string)))
      (concat " "
              (propertize my/sysinfo-string
                          'face 'doom-modeline-buffer-minor-mode)
              " ")))

  (doom-modeline-def-modeline 'main
    '(eldoc bar workspace-name window-number modals matches follow
            buffer-info remote-host buffer-position word-count parrot selection-info)
    '(compilation objed-state my/skk-indicator my/sysinfo-segment misc-info
                  persp-name battery grip irc mu4e gnus github debug repl lsp
                  minor-modes input-method indent-info buffer-encoding
                  major-mode process vcs check time)))

;; ② ミニバッファ: プロンプト末尾 (minibuffer-prompt-end) にオーバーレイ
;;    呼び出し元バッファの SKK 状態を minibuffer-selected-window 経由で参照
(defvar my/skk-minibuffer-overlay nil)

(defun my/skk-minibuffer-update ()
  (when (overlayp my/skk-minibuffer-overlay)
    (let* ((win (minibuffer-selected-window))
           (buf (and win (window-buffer win)))
           (str (cond
                 ;; ミニバッファ内で SKK が有効な場合はそちらを優先
                 ((bound-and-true-p skk-mode)
                  (my/skk-mode-string-in (current-buffer)))
                 ;; 呼び出し元バッファの状態を参照
                 (buf (my/skk-mode-string-in buf)))))
      (overlay-put my/skk-minibuffer-overlay
                   'before-string
                   (if str (concat " " str) "")))))

(add-hook 'minibuffer-setup-hook
          (lambda ()
            (let ((pos (minibuffer-prompt-end)))
              (setq my/skk-minibuffer-overlay
                    (make-overlay pos pos nil t t)))
            (my/skk-minibuffer-update)
            (add-hook 'post-command-hook #'my/skk-minibuffer-update nil t)))

(add-hook 'minibuffer-exit-hook
          (lambda ()
            (when (overlayp my/skk-minibuffer-overlay)
              (delete-overlay my/skk-minibuffer-overlay))
            (setq my/skk-minibuffer-overlay nil)))

(leaf expand-region
  :ensure t
  :bind (("C-." . er/expand-region))
  )

(leaf puni
  :ensure t
  :global-minor-mode puni-global-mode)

(defun my/newline-and-indent-pair ()
  "括弧の間でEnterを押したとき、括弧を展開してインデントする。"
  (interactive)
  (let ((close (char-after)))
    (if (member (list (char-before) close)
                '((?{ ?}) (?\( ?\)) (?\[ ?\])))
        (progn
          (delete-char 1)
          (newline-and-indent)
          (let ((pos (point)))
            (newline)
            (insert close)
            (indent-according-to-mode)
            (goto-char pos)))
      (newline-and-indent))))

(add-hook 'prog-mode-hook
          (lambda ()
            (local-set-key (kbd "RET") #'my/newline-and-indent-pair)
            (when (fboundp 'evil-local-set-key)
              (evil-local-set-key 'insert (kbd "RET") #'my/newline-and-indent-pair))))

(leaf vertico
  :ensure t
  :global-minor-mode t
  :bind
  ((:vertico-map
    ("C-z" . vertico-insert)
    ("C-l" . grugrut/up-dir)))
  :preface
  (defun grugrut/up-dir ()
    "ひとつ上のディレクトリ階層に移動する."
    (interactive)
    (let* ((orig (minibuffer-contents))
           (orig-dir (file-name-directory orig))
           (up-dir (if orig-dir (file-name-directory (directory-file-name orig-dir))))
           (target (if (and up-dir orig-dir) up-dir orig)))
      (delete-minibuffer-contents)
      (insert target)))
  :custom
  (vertico-count . 20)
  (vertico-cycle . t))

(leaf savehist
  :global-minor-mode t)

(leaf vundo
  :ensure t
)

(leaf orderless
  :ensure t
  :custom
  (completion-styles . '(orderless)))

(leaf marginalia
  :ensure t
  :global-minor-mode t)

(leaf consult
  :ensure t
  :bind
  (([remap switch-to-buffer] . consult-buffer)
   ([remap goto-line] . consult-goto-line)
   ([remap yank-pop] . consult-yank-pop)
   ("C-;" . consult-buffer)))

(defun my/org-slugify (str)
  "STR をファイル名に使える文字列に変換する."
  (let* ((s (string-trim str))
         (s (replace-regexp-in-string "\\s-+" "_" s))
         (s (replace-regexp-in-string "[/\\\\:*?\"<>|]" "" s)))
    (if (string-empty-p s) "untitled" s)))

(defun my/org-file-in-dir (dir label filetag headings)
  "DIR 内の org ファイルを completing-read で選択、または新規作成して返す.
LABEL はプロンプト文字列、FILETAG は #+filetags の値、
HEADINGS は新規作成時に挿入するトップレベル見出しのリスト。
既存ファイルは file-name-base で表示し、選択したパスを返す。
'[+ 新規作成]' を選ぶと名前を入力してファイルを作成する。"
  (let* ((dir   (expand-file-name dir))
         (_     (make-directory dir t))
         (files (directory-files dir nil "\\.org\\'" t))
         (new   "[+ 新規作成]")
         (sel   (completing-read
                 (format "%s: " label)
                 (cons new (mapcar #'file-name-base files))
                 nil nil))
         (path  (if (string= sel new)
                    (let* ((name (read-string "名前: "))
                           (slug (my/org-slugify name))
                           (p    (expand-file-name (concat slug ".org") dir)))
                      (unless (file-exists-p p)
                        (with-temp-file p
                          (insert (format "#+title: %s\n#+filetags: :%s:\n\n"
                                          name filetag))
                          (dolist (h headings)
                            (insert (format "* %s\n\n" h)))))
                      p)
                  (expand-file-name (concat sel ".org") dir))))
    path))

;; 各領域のキャプチャターゲット関数
(defun my/org-capture-book ()
  (my/org-file-in-dir "~/org/book" "Book" "book"
                      '("TODO Read" "Notes" "Review")))
(defun my/org-capture-work ()
  (my/org-file-in-dir "~/org/work" "Work" "work"
                      '("Tasks" "Notes")))
(defun my/org-capture-research ()
  (my/org-file-in-dir "~/org/research" "Research" "research"
                      '("Overview" "TODO Tasks" "Notes" "References")))
(defun my/org-capture-personal ()
  (my/org-file-in-dir "~/org/personal" "Personal" "personal"
                      '("Tasks" "Notes")))

;; C-c o x でファイルを選択/作成して直接開く
(defun my/org-open-book ()
  (interactive)
  (find-file (my/org-capture-book)))
(defun my/org-open-work ()
  (interactive)
  (find-file (my/org-capture-work)))
(defun my/org-open-research ()
  (interactive)
  (find-file (my/org-capture-research)))

(global-set-key (kbd "C-c o b") #'my/org-open-book)
(global-set-key (kbd "C-c o w") #'my/org-open-work)
(global-set-key (kbd "C-c o r") #'my/org-open-research)

(defvar my/org-sync-timer nil
  "org 自動同期のデバウンスタイマー.")

(defun my/org-sync ()
  "~/org を GitHub へ非同期で同期する."
  (interactive)
  (let ((script (expand-file-name "~/.conf/scripts/org-sync.sh")))
    (if (not (file-executable-p script))
        (message "org-sync: script not found: %s" script)
      (message "org sync: starting...")
      (set-process-sentinel
       (start-process "org-sync" "*org-sync*" script)
       (lambda (_proc event)
         (cond
          ((string-match "finished" event) (message "org sync: done"))
          ((string-match "exited abnormally" event)
           (message "org sync: failed — see *org-sync* buffer"))))))))

(defun my/org-sync-debounced ()
  "保存から 5 秒後に org sync を実行する（連続保存をまとめる）."
  (when my/org-sync-timer
    (cancel-timer my/org-sync-timer))
  (setq my/org-sync-timer
        (run-with-timer 5 nil #'my/org-sync)))

(add-hook 'after-save-hook
          (lambda ()
            (when (and (buffer-file-name)
                       (string-suffix-p ".org" (buffer-file-name))
                       (string-prefix-p (expand-file-name "~/org/")
                                        (expand-file-name (buffer-file-name))))
              (my/org-sync-debounced))))

(global-set-key (kbd "C-c o s") #'my/org-sync)

(leaf org
  :ensure t
  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   ("C-c l" . org-store-link))
  :custom
  ;; ファイル
  (org-directory . "~/org")
  ;; 各ディレクトリを指定 → 配下の全 .org を自動検出
  (org-agenda-files . '("~/org/book"
                        "~/org/work"
                        "~/org/research"
                        "~/org/personal"
                        "~/org/shared"))
  (org-default-notes-file . "~/org/shared/memo.org")
  ;; TODO ステート
  (org-todo-keywords
   . '((sequence "TODO(t)" "IN-PROGRESS(i!)" "|" "DONE(d!)" "CANCELLED(c@)")))
  (org-todo-keyword-faces
   . '(("TODO"        . (:foreground "#ff6c6b" :weight bold))
       ("IN-PROGRESS" . (:foreground "#ecbe7b" :weight bold))
       ("DONE"        . (:foreground "#98be65" :weight bold))
       ("CANCELLED"   . (:foreground "#5b6268" :weight bold))))
  ;; ログ
  (org-log-done . 'time)
  (org-log-into-drawer . t)
  ;; アジェンダ
  (org-agenda-span . 'week)
  (org-agenda-start-on-weekday . 1)
  (org-agenda-window-setup . 'current-window)
  ;; 外観
  (org-startup-indented . t)
  (org-hide-leading-stars . t)
  (org-ellipsis . " ▾")
  ;; アーカイブ
  (org-archive-location . "~/org/archive.org::* Archive")
  (org-modules . '(ol-bbdb ol-bibtex ol-docview ol-info ol-irc ol-mhe ol-rmail ol-w3m))
  :config
  (setq org-capture-templates
        '(;; デフォルト: shared/memo.org
          ("m" "Memo (デフォルト)" entry
           (file+headline "~/org/shared/memo.org" "Memo")
           "* %?\n  CREATED: %U\n  %i\n  %a"
           :empty-lines 1)
          ;; Book: ファイルを選択/作成 → Notes 見出しへ
          ("b" "Book Note" entry
           (file+headline my/org-capture-book "Notes")
           "** %T\n   %?"
           :empty-lines 1)
          ;; Work: ファイルを選択/作成
          ("w" "Work Task" entry
           (file+headline my/org-capture-work "Tasks")
           "* TODO %?\n  CREATED: %U\n  %i\n  %a"
           :empty-lines 1)
          ("W" "Work Note" entry
           (file+headline my/org-capture-work "Notes")
           "* %?\n  CREATED: %U\n  %i\n  %a"
           :empty-lines 1)
          ;; Research: ファイルを選択/作成 → Notes 見出しへ
          ("r" "Research Note" entry
           (file+headline my/org-capture-research "Notes")
           "** %T\n   %?"
           :empty-lines 1)
          ("R" "Research Task" entry
           (file+headline my/org-capture-research "TODO Tasks")
           "* TODO %?\n  CREATED: %U\n  %i\n  %a"
           :empty-lines 1)
          ;; Personal: ファイルを選択/作成
          ("p" "Personal Task" entry
           (file+headline my/org-capture-personal "Tasks")
           "* TODO %?\n  CREATED: %U\n  %i\n  %a"
           :empty-lines 1)
          ;; Journal: personal/journal.org に日付ツリーで追加
          ("j" "Journal" entry
           (file+olp+datetree "~/org/personal/journal.org")
           "* %?\n  CREATED: %U"
           :empty-lines 1)
          ;; Meeting: shared/meetings.org に追加
          ("M" "Meeting" entry
           (file+headline "~/org/shared/meetings.org" "Meetings")
           "* %^{タイトル} %^g\n  DATE: %T\n  出席: %^{出席者}\n\n** Agenda\n  %?\n\n** Actions\n"
           :empty-lines 1)))
  (with-eval-after-load 'evil
    (evil-define-key 'normal org-mode-map
      (kbd "TAB") #'org-cycle
      (kbd "RET") #'org-open-at-point
      (kbd "t")   #'org-todo
      (kbd "T")   #'org-set-tags-command
      (kbd ">")   #'org-deadline
      (kbd "<")   #'org-schedule
      (kbd "gh")  #'outline-up-heading
      (kbd "gj")  #'org-forward-heading-same-level
      (kbd "gk")  #'org-backward-heading-same-level
      (kbd "gl")  #'outline-next-heading)
    ;; evil の全ステートで M-h/M-l によるウィンドウ移動を有効にする
    ;; define-key org-mode-map だけでは evil のキーマップ階層に埋もれるため
    (evil-define-key '(normal insert visual motion emacs) org-mode-map
      (kbd "M-h") #'previous-multiframe-window
      (kbd "M-l") #'next-multiframe-window))
  ;; ディレクトリ作成
  (dolist (dir '("~/org/book" "~/org/personal"
                 "~/org/research" "~/org/shared" "~/org/work"))
    (make-directory (expand-file-name dir) t))

  ;; org-mode では < の自動補完 (electric-pair-mode) を無効化する
  ;; <s, <q 等の org テンプレート展開と競合するため
  (add-hook 'org-mode-hook
            (lambda ()
              (setq-local electric-pair-inhibit-predicate
                          (lambda (c)
                            (if (char-equal c ?<)
                                t
                              (electric-pair-default-inhibit c))))))

  ;; ─── Org Babel ─────────────────────────────────────────────────────────────
  ;; Python コマンドを明示的に python3 に固定する
  ;; org-babel のデフォルトは "python" だが、mise shim 経由の python と
  ;; pip3 でインストールしたパッケージが入った python3 は別環境のため
  (setq org-babel-python-command "python3")

  ;; 評価対応言語を登録
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python     . t)
     (shell      . t)
     (latex      . t)))

  ;; 評価確認プロンプトを無効（自分で書いたブロックのみ評価する前提）
  (setq org-confirm-babel-evaluate nil)

  ;; インライン画像を起動時・評価後に自動表示
  (setq org-startup-with-inline-images t)
  (add-hook 'org-babel-after-execute-hook #'org-display-inline-images)

  ;; macOS: BasicTeX のバイナリを exec-path に追加 (cask "basictex" 必要)
  (when (eq system-type 'darwin)
    (add-to-list 'exec-path "/Library/TeX/texbin"))

  ;; LaTeX 数式プレビュー: dvipng を使用 (basictex + tlmgr install dvipng)
  (setq org-preview-latex-default-process 'dvipng)
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.8))

  ;; Python: matplotlib グラフ用に Agg バックエンドを prologue で自動設定
  ;; 各ブロックで plt.savefig('<file>') して `:results file :file <file>` を指定する
  (with-eval-after-load 'ob-python
    (unless (assoc :prologue org-babel-default-header-args:python)
      (push '(:prologue . "try:\n    import matplotlib as _mpl; _mpl.use('Agg')\nexcept ImportError:\n    pass\n")
            org-babel-default-header-args:python))))

(leaf org-download
  :ensure t
  :after org
  :custom
  ;; 画像の保存先: org ファイルと同じディレクトリの images/ サブディレクトリ
  (org-download-method . 'directory)
  (org-download-image-dir . "images")
  ;; ファイル名に timestamp を使う
  (org-download-timestamp . "%Y%m%d-%H%M%S_")
  ;; 貼り付け後にインライン画像を自動表示
  (org-download-display-inline-images . t)
  ;; macOS: pngpaste でクリップボードから貼り付け
  (org-download-screenshot-method . "pngpaste %s")
  :bind
  (:org-mode-map
   ;; C-c i p : クリップボードの画像を貼り付け
   ("C-c i p" . org-download-clipboard)
   ;; C-c i s : スクリーンショットを撮って貼り付け
   ("C-c i s" . org-download-screenshot)))

(leaf avy
  :ensure t
  :bind
  (("C-:" . avy-goto-char-timer)
   ("C-*" . avy-resume)
   ("M-g M-g" . avy-goto-line))
  :config
  (leaf avy-zap
    :ensure t
    :bind
    ([remap zap-to-char] . avy-zap-to-char)))

(leaf ace-window
  :ensure t
  :bind
  (("C-x o" . ace-window))
  :config
  (setopt aw-keys '(?a ?s ?d ?f ?g ?h ?i ?j ?k ?l))
  :custom-face
  (aw-leading-char-face . '((t (:height 3.0)))))

(leaf winum
  :ensure t
  :bind
  (("M-1" . winum-select-window-1)
   ("M-2" . winum-select-window-2)
   ("M-3" . winum-select-window-3)
   ("M-4" . winum-select-window-4)
   ("M-5" . winum-select-window-5)
   ("M-6" . winum-select-window-6)
   ("M-7" . winum-select-window-7)
   ("M-8" . winum-select-window-8)
   ("M-9" . winum-select-window-9))
  :config
  (with-no-warnings (winum-mode 1)))

(defvar my/zoom-window-config nil
  "Saved window configuration before zoom.")

(defun my/toggle-zoom-window ()
  "Toggle zoom of current window like tmux C-z."
  (interactive)
  (if my/zoom-window-config
      (progn
        (set-window-configuration my/zoom-window-config)
        (setq my/zoom-window-config nil))
    (setq my/zoom-window-config (current-window-configuration))
    (delete-other-windows)))

(global-set-key (kbd "M-z") #'my/toggle-zoom-window)
(with-eval-after-load 'evil
  (evil-define-key '(normal insert visual motion emacs) 'global
    (kbd "M-z") #'my/toggle-zoom-window))

(leaf-keys (("C-h" . backward-delete-char)
            ("M-h" . previous-multiframe-window)
            ("M-l" . next-multiframe-window)
            ("C-c h" . describe-bindings)
            ("C-c H" . my/show-keybindings)))

(defun my/show-keybindings ()
  "Emacs/docs/operations.md を Markdown プレビューで表示する."
  (interactive)
  (let* ((conf-dir (file-name-directory
                    (directory-file-name
                     (file-name-directory (or load-file-name buffer-file-name
                                              (expand-file-name "~/.emacs.d/init.el"))))))
         (ops-file (expand-file-name "Emacs/docs/operations.md" conf-dir))
         (fallback (expand-file-name "~/.conf/Emacs/docs/operations.md"))
         (target (cond ((file-exists-p ops-file) ops-file)
                       ((file-exists-p fallback) fallback))))
    (if target
        (with-current-buffer (find-file-noselect target)
          (my/markdown-preview))
      (message "operations.md が見つかりません: %s" ops-file))))

(leaf which-key
  :global-minor-mode t)

(leaf magit
  :ensure t
  :bind
  (("C-x g" . magit-status)))

(leaf recentf
  :init
  (recentf-mode)
  :config
  (setopt recentf-max-saved-items 5000)
  (setopt recentf-auto-cleanup 'never))

(leaf git-gutter
  :ensure t
  :global-minor-mode global-git-gutter-mode
  :custom
  ((git-gutter:added-sign . "++")
   (git-gutter:deleted-sign . "--")
   (git-gutter:modified-sign . "==")))

(leaf treesit
  :config
  (setopt treesit-font-lock-level 4)
  (setopt treesit-language-source-alist
        '((bash "https://github.com/tree-sitter/tree-sitter-bash")
          (css "https://github.com/tree-sitter/tree-sitter-css")
          (elisp "https://github.com/Wilfred/tree-sitter-elisp")
          (go "https://github.com/tree-sitter/tree-sitter-go")
          (html "https://github.com/tree-sitter/tree-sitter-html")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (markdown "https://github.com/ikatyang/tree-sitter-markdown")
          (toml "https://github.com/tree-sitter/tree-sitter-toml")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
          (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
)

(leaf eglot
  :config
  (dolist (hook '(typescript-mode-hook
                  tsx-ts-mode-hook
                  go-mode-hook
                  go-ts-mode-hook
                  python-mode-hook
                  python-ts-mode-hook
                  html-mode-hook
                  terraform-mode-hook))
    (add-hook hook #'eglot-ensure))
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(terraform-mode . ("terraform-ls" "serve")))
    ;; TypeScript: プロジェクト内エクスポートの補完とauto-importを有効化
    (defun my/eglot-ts-workspace-config ()
      (setq-local eglot-workspace-configuration
                  '(:typescript (:suggest (:autoImports t
                                           :includeCompletionsForModuleExports t
                                           :completeFunctionCalls t))
                    :javascript (:suggest (:autoImports t
                                           :includeCompletionsForModuleExports t)))))
    (dolist (hook '(typescript-mode-hook typescript-ts-mode-hook tsx-ts-mode-hook
                    js-mode-hook js-ts-mode-hook))
      (add-hook hook #'my/eglot-ts-workspace-config))
    ;; ddskk との競合修正: SKK の変換操作が after-change-functions をスキップする
    ;; ケースで before-change が記録した生エントリ (lsp-beg lsp-end (pos . marker) ...)
    ;; が JSON シリアライズ時に cons cell として渡されエラーになる問題を回避する。
    ;; 未処理エントリを検出したら eglot の :emacs-messup フルシンクにフォールバック。
    (advice-add 'eglot--signal-textDocument/didChange :before
      (lambda ()
        (when (and (listp eglot--recent-changes)
                   (cl-some (lambda (change)
                              (consp (nth 2 change)))
                            eglot--recent-changes))
          (setq eglot--recent-changes :emacs-messup))))))

(leaf dumb-jump
  :ensure t
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(leaf xref
  :config
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(with-eval-after-load 'evil
  (evil-define-key 'normal 'global
    (kbd "gd") #'xref-find-definitions
    (kbd "gr") #'xref-find-references
    (kbd "C-t") #'xref-go-back))

(when (< emacs-major-version 31)
  (leaf corfu-terminal
    :ensure t
    :config
    (defun my/corfu-terminal-update (frame)
      (if (display-graphic-p frame)
          (corfu-terminal-mode -1)
        (corfu-terminal-mode +1)))
    (add-hook 'after-make-frame-functions #'my/corfu-terminal-update)
    (unless (display-graphic-p)
      (corfu-terminal-mode +1))))

(leaf corfu
  :custom ((corfu-auto . t)
           (corfu-auto-delay . 0)
           (corfu-auto-prefix . 1)
           (corfu-cycle . t)
           (corfu-on-exact-match . nil)
           (tab-always-indent . 'complete))
  :init
  (global-corfu-mode +1)

  :config
  (define-key corfu-map (kbd "TAB") #'corfu-insert)
  (define-key corfu-map (kbd "<tab>") #'corfu-insert)
  (define-key corfu-map (kbd "RET") #'corfu-insert)
  (define-key corfu-map (kbd "<return>") #'corfu-insert)

  ;; java-mode などの一部のモードではタブに `c-indent-line-or-region` が割り当てられているので、
  ;; 補完が出るように `indent-for-tab-command` に置き換える
  (defun my/corfu-remap-tab-command ()
    (global-set-key [remap c-indent-line-or-region] #'indent-for-tab-command))
  (add-hook 'java-mode-hook #'my/corfu-remap-tab-command)

  ;; ミニバッファー上でverticoによる補完が行われない場合、corfuの補完が出るようにします。
  ;; https://github.com/minad/corfu#completing-in-the-minibuffer
  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p mct--active)
                (bound-and-true-p vertico--input))
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)

  ;; lsp-modeでcorfuが起動するように設定する
  (with-eval-after-load 'lsp-mode
    (setq lsp-completion-provider :none)))

(leaf cape
  :ensure t
  :hook (((prog-mode
           text-mode
           conf-mode
           eglot-managed-mode) . my/set-super-capf))
  :config
  (setq cape-dabbrev-check-other-buffers nil)

  (defun my/set-super-capf (&optional arg)
    (setq-local completion-at-point-functions
                (list (cape-capf-noninterruptible
                       (cape-capf-buster
                        (cape-capf-properties
                         (cape-capf-super
                          (if arg arg (car completion-at-point-functions))
                          #'cape-dabbrev
                          #'cape-file)
                         :sort t
                         :exclusive 'no))))))

  (add-to-list 'completion-at-point-functions #'cape-file t)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev t)
  (add-to-list 'completion-at-point-functions #'cape-keyword t))

(leaf yasnippet
  :ensure t
  :blackout yas-minor-mode
  :global-minor-mode yas-global-mode
  :custom ((yas-indent-line . 'fixed))
  :config
  (define-key yas-keymap (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "C-c y i") #'yas-insert-snippet)
  (define-key yas-minor-mode-map (kbd "C-c y n") #'yas-new-snippet)
  (define-key yas-minor-mode-map (kbd "C-c y v") #'yas-visit-snippet-file)
  (define-key yas-minor-mode-map (kbd "C-c y l") #'yas-describe-tables)
  (define-key yas-minor-mode-map (kbd "C-c y g") #'yas-reload-all)
  (leaf yasnippet-snippets :ensure t)
  (leaf yatemplate
    :commands (yatemplate-fill-alist)
    :ensure t
    :config
    (yatemplate-fill-alist))
  (defvar company-mode/enable-yas t
    "Enable yasnippet for all backends.")
  (defun company-mode/backend-with-yas (backend)
    (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
        backend
      (append (if (consp backend) backend (list backend))
              '(:with company-yasnippet)))))

(leaf flymake
  :global-minor-mode t)

(leaf project
  :custom
  (project-vc-merge-submodules . nil) ; Git Submoduleは別のプロジェクトとして扱う
  (project-vc-extra-root-markers . '("pyproject.toml" "uv.lock" "setup.py" "Pipfile")))

(leaf editorconfig
  :global-minor-mode t)

(when (display-graphic-p)
  (leaf indent-bars
    :vc (:url "https://github.com/jdtsmith/indent-bars")
    :hook
    prog-mode-hook cc-mode-hook org-mode-hook
    :config
    (require 'indent-bars-ts)
    :custom
    (indent-bars-treesit-support . t)
    (indent-bars-treesit-ignore-blank-lines-types . '("module"))
    (indent-bars-pattern . ".")
    (indent-bars-width-frac . 0.2)
    (indent-bars-pad-frac . 0.2)
    (indent-bars-color-by-depth . '(:regexp "outline-\\([0-9]+\\)" :blend 1))
    (indent-bars-highlight-current-depth . '(:pattern "." :pad 0.1 :width 0.45))))

(leaf llm
  :vc (:url "https://github.com/ahyatt/llm/tree/main")
  :require llm-gemini
  :config
  (when (file-exists-p "~/.emacs.d/secrets.el")
    (load "~/.emacs.d/secrets.el")
    (setq llm-gemini (make-llm-gemini :key gemini-api-key))
    (setq ellama-provider llm-gemini)))

(leaf ellama
  :ensure t
  :bind
  ("C-c e" . ellama-transient-main-menu)
  :custom
  (ellama-language . "Japanese"))

(leaf reformatter
  :ensure t
  :config
  (reformatter-define prettier-ts-format
    :program "prettier"
    :args (list "--stdin-filepath" (or (buffer-file-name) "dummy.ts")))
  (dolist (hook '(typescript-mode-hook
                  tsx-ts-mode-hook
                  typescript-ts-mode-hook
                  js-mode-hook
                  js-ts-mode-hook))
    (add-hook hook #'prettier-ts-format-on-save-mode)))

(leaf typescript-mode
  :ensure t
  :mode
  (("\\.ts\\'" . typescript-mode)
   ("\\.tsx\\'" . tsx-ts-mode))
  :custom
  (typescript-indent-level . 2)
  (js-indent-level . 2)
  :config
  (defun my/ts-electric-pair-angle-bracket ()
    (setq-local electric-pair-pairs
                (append electric-pair-pairs '((?< . ?>))))
    (setq-local electric-pair-text-pairs electric-pair-pairs))
  (dolist (hook '(typescript-mode-hook tsx-ts-mode-hook typescript-ts-mode-hook
                  js-mode-hook js-ts-mode-hook))
    (add-hook hook #'my/ts-electric-pair-angle-bracket)))

(leaf terraform-mode
  :ensure t
  :mode (("\\.tf\\'" . terraform-mode)
         ("\\.hcl\\'" . terraform-mode))
  :hook (terraform-mode-hook . terraform-format-on-save-mode))

(defvar my/markdown-preview-css
  "body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;font-size:16px;line-height:1.6;color:#24292e;background:#fff;padding:32px;max-width:900px;margin:0 auto}h1,h2{border-bottom:1px solid #eaecef;padding-bottom:.3em}h1,h2,h3,h4,h5,h6{margin-top:24px;margin-bottom:16px;font-weight:600;line-height:1.25}code,tt{background-color:rgba(27,31,35,.05);border-radius:3px;font-size:85%;padding:.2em .4em}pre{background-color:#f6f8fa;border-radius:6px;font-size:85%;line-height:1.45;overflow:auto;padding:16px}pre code,pre tt{background:transparent;border:0;font-size:100%;padding:0;word-break:normal}blockquote{border-left:.25em solid #dfe2e5;color:#6a737d;padding:0 1em;margin:0 0 16px}table{border-collapse:collapse;width:100%;margin-bottom:16px}td,th{border:1px solid #dfe2e5;padding:6px 13px}tr:nth-child(2n){background-color:#f6f8fa}img{max-width:100%;box-sizing:content-box}a{color:#0366d6;text-decoration:none}a:hover{text-decoration:underline}hr{border:0;border-top:1px solid #eaecef;margin:24px 0}ul,ol{padding-left:2em;margin-bottom:16px}li+li{margin-top:.25em}"
  "GitHub 風 CSS for markdown preview.")

(defun my/markdown-preview--render (buf)
  "BUF のマークダウンを HTML に変換し、ファイルパスを返す."
  (let* ((md-tmp (unless (buffer-file-name buf)
                   (let ((f (make-temp-file "md-src-" nil ".md")))
                     (with-current-buffer buf
                       (write-region (point-min) (point-max) f))
                     f)))
         (md-file (or (buffer-file-name buf) md-tmp))
         (html-file (make-temp-file "md-preview-" nil ".html"))
         (css-file (make-temp-file "md-css-" nil ".css")))
    (write-region my/markdown-preview-css nil css-file)
    (unless (= 0 (call-process "pandoc" nil nil nil
                               "-f" "gfm"
                               "-t" "html5"
                               "--standalone"
                               "--embed-resources"
                               "--syntax-highlighting=tango"
                               (format "--css=%s" css-file)
                               "-o" html-file
                               md-file))
      (delete-file css-file)
      (when md-tmp (delete-file md-tmp))
      (error "pandoc の実行に失敗しました"))
    (delete-file css-file)
    (when md-tmp (delete-file md-tmp))
    html-file))

(defun my/markdown-preview ()
  "現在のマークダウンバッファを shr でプレビューする."
  (interactive)
  (let* ((src-buf (current-buffer))
         (html-file (my/markdown-preview--render src-buf))
         (preview-buf-name (format "*md-preview: %s*"
                                   (or (buffer-file-name src-buf)
                                       (buffer-name src-buf)))))
    (with-current-buffer (get-buffer-create preview-buf-name)
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert-file-contents html-file)
        (let ((dom (libxml-parse-html-region (point-min) (point-max))))
          (erase-buffer)
          (shr-insert-document dom)))
      (goto-char (point-min))
      (special-mode)
      (pop-to-buffer (current-buffer)))))

(define-minor-mode my/markdown-auto-preview-mode
  "保存時に自動でマークダウンプレビューを更新するマイナーモード."
  :lighter " MdPv"
  (if my/markdown-auto-preview-mode
      (add-hook 'after-save-hook #'my/markdown-preview nil t)
    (remove-hook 'after-save-hook #'my/markdown-preview t)))

(leaf markdown-mode
  :ensure t
  :mode
  (("\\.md\\'" . gfm-mode))
  :bind
  (:gfm-mode-map
   ("C-c C-v" . my/markdown-preview)
   ("C-c C-x v" . my/markdown-auto-preview-mode)))

(leaf slack
  :ensure t
  :commands (slack-start)
  :bind
  (("C-c s s" . slack-start)
   ("C-c s c" . slack-channel-select)
   ("C-c s m" . slack-im-select)
   (:slack-mode-map
    ("C-c C-j" . slack-message-write-another-buffer)))
  :custom
  (slack-buffer-emojify . t)
  (slack-prefer-current-team . t)
  :config
  (let ((token (auth-source-pick-first-password
                :host "slack-emacs-token"
                :user "atsushi@aquamarine-cloud.net"))
        (cookie (auth-source-pick-first-password
                 :host "slack-emacs-cookie"
                 :user "atsushi@aquamarine-cloud.net")))
    (when (and token cookie)
      (slack-register-team
       :name "slack"
       :default t
       :token token
       :cookie cookie))))
