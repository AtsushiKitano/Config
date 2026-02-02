(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")
                       )
   )
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
;; initialize leaf-keywords.el
    (leaf-keywords-init)
  )
)


(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

;; ここにいっぱい設定を書く
(setq mac-command-modifier 'meta)

(setq default-frame-alist
      (append'((alpha . 85)
               )
             default-frame-alist))
(setq initial-frame-alist default-frame-alist)

;; Themes
(leaf doom-themes
  :ensure t neotree
  :custom
  (doom-themes-enable-italic . nil)
  (doom-themes-enable-bold . nil)
  :config
  (load-theme 'doom-tomorrow-night t)
  (doom-themes-neotree-config)
  (doom-themes-org-config)
  )

(leaf *modeline-settings
  :config
  ;; doom-modeline
  ;; doom を利用した mode-line
  (leaf doom-modeline
    :ensure t
    :commands (doom-modeline-def-modeline)
    :custom
    (doom-modeline-buffer-file-name-style . 'truncate-with-project)
    (doom-modeline-icon . t)
    (doom-modeline-major-mode-icon . nil)
    (doom-modeline-minor-modes . nil)
    :hook (after-init-hook . doom-modeline-mode)
    :config
    (line-number-mode 0)
    (column-number-mode 0)
    (doom-modeline-def-modeline 'main
      '(bar window-number matches buffer-info remote-host buffer-position parrot selection-info)
      '(misc-info persp-name lsp github debug minor-modes input-method major-mode process vcs ))
    )
    ;; Hide mode line
  ;; 特定のモードでモードラインを非表示にする
  (leaf hide-mode-line
    :ensure t neotree minimap imenu-list
    :hook
    ((neotree-mode imenu-list-minor-mode minimap-mode) . hide-mode-line-mode)
    )
  )

;; 全体設定
(leaf general-setting
  :config
  (define-key global-map (kbd "C-{") 'hs-hide-block)
  (define-key global-map (kbd "C-}") 'hs-show-block)
  (define-key global-map (kbd "C-d") 'delete-forward-char)
  (define-key global-map (kbd "C-f") 'forward-char)
  (define-key global-map (kbd "C-k") 'kill-line)
  (define-key global-map (kbd "C-e") 'move-end-of-line)
  (define-key global-map [?¥] [?\\])
  (prefer-coding-system 'utf-8-unix)
  (defalias 'yes-or-no-p 'y-or-n-p) ; yes-or-no-pをy/nで選択できるようにする
  ;; recentf
  (defvar recentf-max-saved-items 1000)
  (defvar recentf-auto-cleanup 'never)
  (global-set-key [mouse-2] 'mouse-yank-at-click)
  (delete-selection-mode t) ; リージョン選択時にリージョンまるごと削除
  (global-display-line-numbers-mode t)
  (set-face-attribute 'line-number-current-line nil
                      :foreground "gold")

  ;; 対応する括弧を光らせる
  (show-paren-mode t)
  (defvar show-paren-style 'mixed)
  ;; カーソルを点滅させない
  (blink-cursor-mode 0)
  ;; 単語での折り返し
  (leaf visual-line-mode
    :require simple
    :config
    (global-visual-line-mode t))

  ;; FONT
  (add-to-list 'default-frame-alist
             '(font . "Monospace-18"))

  ;; set markの領域の色の設定
  (set-face-attribute 'region nil :background "#ca6500")
  ;; マウスを避けさせる
  (mouse-avoidance-mode 'jump)
  (setq frame-title-format "%f")

  :setq
  `((large-file-warning-threshold . ,(* 25 1024 1024))
    (read-file-name-completion-ignore-case . t)
    (use-dialog-box                        . nil)
    (history-length                        . 500)
    (history-delete-duplicates             . t)
    (line-move-visual                      . nil)
    (mouse-drag-copy-region                . t)
    (backup-inhibited                      . t)
    (inhibit-startup-message               . t)
    (require-final-newline                 . t)
    (next-line-add-newlines                . nil)
    (frame-title-format                    . "%f")
    (truncate-lines                        . t)
    (mac-option-key-is-meta . nil)
    (ns-right-alternate-modifier . nil)
    (read-process-output-max               . ,(* 1024 1024)))
  :setq-default
  (indent-tabs-mode . nil) ; タブはスペースで
  (tab-width        . 2)
  (require-final-newline . t)
  )

(leaf smartparens
  :ensure t
  :require smartparens-config
  :bind (
         ("C-M-a" . sp-beginning-of-sexp)              ;; カーソルが括弧の中か上にある場合、括弧の先頭に移動
         ("C-M-e" . sp-end-of-sexp)                    ;; カーソルが括弧の中か上にある場合、括弧の最後に移動
         ("C-M-d" . sp-down-sexp)          ;; 現在いる括弧の中にさらにネストした括弧がある場合その括弧に移動
         ("C-M-u" . sp-up-sexp)            ;; 現在いる括弧の外の閉じ括弧に移動
         ("C-M-w" . sp-backward-down-sexp) ;; カーソルから見て後ろにネストした括弧がある場合は、そのネストに入っていく
         ("C-M-q" . sp-backward-up-sexp)   ;; カーソルより後ろに上位の括弧がある場合はその上位の括弧に移動する
         ("C-M-f" . sp-forward-symbol)     ;; 次のシンボルへざっくり移動する。M-f良いような気がする。
         ("C-M-b" . sp-backward-symbol)    ;; 前のシンボルへざっくり移動する。M-bで良いような気がする。
         ("C-M-n" . sp-next-sexp)          ;; 現在のカーソルがある階層で次の括弧へ移動する
         ("C-M-p" . sp-previous-sexp)      ;; 現在のカーソルがある階層で前の括弧へ移動する
         ("C-s-f" . sp-forward-sexp)                   ;; カーソルからの次の括弧へ移動する。
         ("C-s-b" . sp-backward-sexp)                  ;; カーソルからの前の括弧へ移動する。
              ;; カーソルがある位置のワードをその括弧で囲う
         ("C-c ("  . wrap-with-parens)
         ("C-c ["  . wrap-with-brackets)
         ("C-c {"  . wrap-with-braces)
         ("C-c '"  . wrap-with-single-quotes) ;; lisp-modeではシングルクオーはテキストではなく変数のオブジェクト化で使われるので、利用できない
         ("C-c \"" . wrap-with-double-quotes)
         ;;          ;;("M-<" . sp-backward-unwrap-sexp)  ;; input系のM-[プレフィックスにぶつかり、予期せない挙動が出るのでショートカットを変更する。
         ("M-]" . sp-unwrap-sexp) ;; 現在のカーソルがる位置の括弧を解除する
              ;;          ("C-<right>" . sp-forward-slurp-sexp) ;; 括弧が囲む範囲を右に拡張する
              ;;          ("C-<left>" . sp-forward-barf-sexp) ;; 括弧が囲む範囲を左に縮小する。
         ("M-k" . sp-kill-sexp))
  :init
  (smartparens-global-mode t)
  (setq electric-pair-strict-mode nil)
  (require 'smartparens-config)
  :custom (
           (electric-pair-mode . nil)
           )
  )

(leaf evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)

  (let ((map evil-insert-state-map))
    (define-key map (kbd "C-p") 'previous-line)
    (define-key map (kbd "C-n") 'next-line)
    (define-key map (kbd "C-b") 'backward-char)
    (define-key map (kbd "C-f") 'forward-char)
    (define-key map (kbd "C-a") 'move-beginning-of-line)
    (define-key map (kbd "C-e") 'move-end-of-line)
    (define-key map (kbd "M-f") 'forward-word)
    (define-key map (kbd "M-b") 'backward-word)
    (define-key map (kbd "C-d") 'delete-char)
    (define-key map (kbd "C-h") 'backward-delete-char)
    (define-key map (kbd "C-k") 'kill-line)
    (define-key map (kbd "C-w") 'backward-kill-word)
    (define-key map (kbd "C-y") 'yank)
    (define-key map (kbd "M-d") 'kill-word)
    (define-key map (kbd "C-g") 'evil-normal-start)
    ))

(leaf blacken
  :ensure t
  :hook (python-mode . blacken-mode)
  :custom ((blacken-line-lenght . 119)
           (blacken-skip-string-normalization . t))
  :config (add-hook 'before-save-hook #'blacken-buffer nil t))

(leaf line-number-mode
  :custom
  ((linum-format . "%5d"))
  (line-number-mode . nil)
  )

(leaf cus-start
  :doc "起動時の設定のカスタマイズ"
  :tag "builtin" "internal"
  :preface
  (defun c/redraw-frame nil
    (interactive)
    (redraw-frame))

  :bind (("M-ESC ESC" . c/redraw-frame))
  :custom '((user-full-name . "Atsushi Kitano")
            (user-mail-address . "atsushi@aquamarine-cloud.net")
            (user-login-name . "atsushi")
            (fill-column . 72)
            (create-lockfiles . nil)
            (debug-on-error . t)
            (init-file-debug . t)
            (frame-resize-pixelwise . t)
            (enable-recursive-minibuffers . t)
            (history-length . 1000)
            (history-delete-duplicates . t)
            (scroll-preserve-screen-position . t)
            (scroll-conservatively . 100)
            (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
            (ring-bell-function . 'ignore)
            (text-quoting-style . 'straight)
            (truncate-lines . t)
            (use-dialog-box . nil)
            (use-file-dialog . nil)
            (menu-bar-mode .  t)
            (tool-bar-mode . nil)
            (scroll-bar-mode . t)
            (indent-tabs-mode . t)
            (auto-save-default . t)
            (auto-save-timeout . 15)
            (auto-save-interval . 60)
            (make-backup-files . t)
            (backup-by-copying . t)
            )
  :config
  (defalias 'yes-or-no-p 'y-or-n-p)
  ;; (keyboard-translate ?\C-h ?\C-?)
  )

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 1))
  :global-minor-mode global-auto-revert-mode)

(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :global-minor-mode delete-selection-mode)

(leaf paren
  :doc "highlight matching paren"
  :tag "builtin"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)

(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :custom ((kill-ring-max . 100)
           (kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))

(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
            (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)))

(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

;; 補完機能
(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :bind (("C-s" . swiper)))

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t)
  )

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :custom ((prescient-aggressive-file-save . t))
  :global-minor-mode prescient-persist-mode)

(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)

(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "minor-mode" "tools" "languages" "convenience" "emacs>=24.3"
  :url "http://www.flycheck.org"
  :ensure t
  :init (global-flycheck-mode)
  :hook (prog-mode-hook . flycheck-mode)
  :custom ((flycheck-display-errors-delay . 0.3))
  :config
  (leaf flycheck-inline
    :ensure t
    :hook (flycheck-mode-hook . flycheck-inline-mode))
  (leaf flycheck-color-mode-line
    :ensure t
    :hook (flycheck-mode-hook . flycheck-color-mode-line-mode))
  (with-eval-after-load 'flycheck-python
    (flycheck-define-checker python-mypy
      "A Python syntax checker using mypy."
      :command ("mypy" "--strict" source-original) ; ここで引数を追加
      :error-patterns
      ((error line-col-string
              (info file) ":" line ":" column ":"
              (message) "(.*\\|\\n)*"
              ;; For "note: " lines that indicate related locations
              (file nil) ":[0-9]+:[0-9]+:"
              " note: " ".*"))
      :modes python-mode
      :priority 1) ; 他のPythonチェッカーより優先度を上げる
    (add-to-list 'flycheck-checkers 'python-mypy t)) ; リストの先頭に追加
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode)

(leaf company-lsp)

(leaf company
  :doc "Modular text completion framework"
  :url "http://company-mode.github.io/"
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence)))
  :global-minor-mode global-company-mode)

(leaf company-c-headers
  :doc "Company mode backend for C/C++ header files"
  :ensure t
  :after company
  :defvar company-backends
  :config
  (add-to-list 'company-backends 'company-c-headers))

(leaf imenu
  :tag "builtin"
  :custom
  (imenu-auto-rescan . t))

(leaf imenu-list
  :ensure t
  :custom
  ((imenu-list-auto-resize . nil)
   (imenu-list-focus-after-activation . nil)
   (imenu-list-position . 'left))
  :hook
  (imenyes
   u-list-major-mode-hook . (lambda ()
                                  (setq mode-line-format nil)
                                  (display-line-numbers-mode 0)))
  )

(leaf-keys (("C-h" . backward-delete-char)
            ("M-h" . previous-multiframe-window)
            ("M-l" . next-multiframe-window)
            ("M-z" . delete-other-windows)))

(leaf electric
  :doc "window maker and command loop for `electric' modes"
  :tag "builtin"
  :added "2022-04-24"
  :config (electric-pair-mode 1))


;; Gitの設定
(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "compat-28.1.1.0" "dash-20210826" "git-commit-20220222" "magit-section-20220325" "transient-20220325" "with-editor-20220318"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :url "https://github.com/magit/magit"
  :added "2022-10-10"
  :emacs>= 25.1
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-popup))
  )

;; Gitの差分表示
(leaf git-gutter-fringe
  :doc "Fringe version of git-gutter.el"
  :url "https://github.com/emacsorphanage/git-gutter-fringe"
  :ensure t
  :custom ((git-gutter:lighter . "")
           (global-git-gutter-mode . t))
  )

;; Icon の表示
(leaf all-the-icons
  :ensure t
  :init (leaf memoize :ensure t)
  :require t
)

;; 日本語表示 ( SKK の設定)
(leaf ddskk
  ;; :straight t
  :bind
  (("C-x C-j" . skk-mode)
   ("M-j"   . skk-mode)
   )
  :init
  (defvar dired-bind-jump nil)  ; dired-xがC-xC-jを奪うので対処しておく
  :custom
  (skk-use-azik . t)                     ; AZIKを使用する
  (skk-azik-keyboard-type . 'jp106)      ;
  (skk-preload . t)
  (skk-byte-compile-init-file . t)
  (skk-indicator-use-cursor-color . nil)
  (skk-indicator-prefix . "")
  (skk-egg-like-newline . t)
  (skk-show-annotation . nil)
  (skk-undo-kakutei-word-only . t)
  (skk-henkan-strict-okuri-precedence . t)
  (default-input-method . "japanese-skk")
  (skk-show-inline . t)
  )

(leaf yasnippet
  :ensure t
  :blackout yas-minor-mode
  :custom ((yas-indent-line . 'fixed)
           (yas-global-mode . t)
           )
  :bind ((yas-keymap
          ("<tab>" . nil))            ; conflict with company
         (yas-minor-mode-map
          ("C-c y i" . yas-insert-snippet)
          ("C-c y n" . yas-new-snippet)
          ("C-c y v" . yas-visit-snippet-file)
          ("C-c y l" . yas-describe-tables)
          ("C-c y g" . yas-reload-all)))
  :config
  (leaf yasnippet-snippets :ensure t)
  (leaf yatemplate
    :commands (yatemplate-fill-alist )
    :ensure t
    :config
    (yatemplate-fill-alist))
  (defvar company-mode/enable-yas t
    "Enable yasnippet for all backends.")
  (defun company-mode/backend-with-yas (backend)
    (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
        backend
      (append (if (consp backend) backend (list backend))
              '(:with company-yasnippet))))
  )

;; 括弧の強調
(leaf rainbow-delimiters
  :ensure t
  :hook
  ((prog-mode-hook . rainbow-delimiters-mode)))

; スペース、タブの空白表示
(leaf whitespace
  :ensure t
  :commands whitespace-mode
  :bind ("C-c W" . whitespace-cleanup)
  :custom ((whitespace-style . '(face
                                trailing
                                tabs
                                spaces
                                empty
                                space-mark
                                tab-mark))
           (whitespace-display-mappings . '((space-mark ?\u3000 [?\u25a1])
                                            (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
           (whitespace-space-regexp . "\\(\u3000+\\)")
           (whitespace-global-modes . '(emacs-lisp-mode shell-script-mode sh-mode python-mode org-mode))
           (global-whitespace-mode . t))

  :config
  (set-face-attribute 'whitespace-trailing nil
                      :background "Black"
                      :foreground "DeepPink"
                      :underline t)
  (set-face-attribute 'whitespace-tab nil
                      :background "Black"
                      :foreground "LightSkyBlue"
                      :underline t)
  (set-face-attribute 'whitespace-space nil
                      :background "Black"
                      :foreground "GreenYellow"
                      :weight 'bold)
    (set-face-attribute 'whitespace-empty nil
                      :background "Black")
  )

;; コードの先頭・末尾への移動 C-a, C-e
(leaf mwim
  :ensure t
  :bind (("C-a" . mwim-beginning-of-code-or-line)
            ("C-e" . mwim-end-of-code-or-line)))

;; Shell
;; Emacsのターミナル vtermの設定
(leaf vterm
  ;; requirements: brew install cmake libvterm libtool
  :ensure t
  :bind (("M-t" . vterm))
  :custom
  (vterm-max-scrollback . 10000)
  (vterm-buffer-name-string . "vterm: %s")
  ;; delete "C-h", add <f1> and <f2>
  (vterm-keymap-exceptions
   . '("<f1>" "<f2>" "C-c" "C-x" "C-u" "C-g" "C-l" "M-x" "M-o" "C-v" "M-v" "C-y" "M-y"))
    ;; 行の表示しない
  :config
  :hook (vterm-mode-hook . (lambda ()
                             (display-line-numbers-mode -1)))
  )

(leaf vterm-toggle
  :ensure t
  :custom
  (vterm-toggle-scope . 'project)
  :config
  ;; Show vterm buffer in the window located at bottom
  (add-to-list 'display-buffer-alist
               '((lambda(bufname _) (with-current-buffer bufname (equal major-mode 'vterm-mode)))
                 (display-buffer-reuse-window display-buffer-in-direction)
                 (direction . bottom)
                 (reusable-frames . visible)
                 (window-height . 0.4)))
  ;; Above display config affects all vterm command, not only vterm-toggle
  (defun my/vterm-new-buffer-in-current-window()
    (interactive)
    (let ((display-buffer-alist nil))
            (vterm)))
  )

;; Program Configures

;; Claude Code
(leaf claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup))


;; reformat
(leaf reformatter
  :ensure t
  :config
  (reformatter-define go-format
    :program "goimports")
  (reformatter-define web-format
    :program "npx"
    :args `("prettier" "--stdin-filepath" buffer-file-name "--tab-width" "2"))
  (reformatter-define python-format
    :program "ruff"
    :args `("format" "--stdin-filename", buffer-file-name))
  :hook
  (go-ts-mode . go-format-on-save-mode)
  (tsx-ts-mode . web-format-on-save-mode)
  (json-ts-mode . web-format-on-save-mode)
  (graphql-mode . web-format-on-save-mode)
  (prisma-mode . web-format-on-save-mode)
  (python-ts-mode . python-format-on-save-mode)
  )

(declare-function web-format-region "reformatter")
(declare-function web-format-on-save-mode "reformatter")
(declare-function python-format-region "reformatter")
(declare-function go-format-region "reformatter")


(leaf lsp-mode
  :ensure t
  :require t
  :commands lsp
  :hook
  (go-mode-hook . lsp)
  (web-mode-hook . lsp)
  (typescript-mode-hook . lsp)
  (python-mode . lsp)
  :config
  (setq lsp-disabled-clients '(tfls))
  (leaf lsp-ui
    :ensure t
    :require t
    :hook
    (lsp-mode-hook . lsp-ui-mode)
    :custom
    (lsp-ui-sideline-enable . nil)
    (lsp-prefer-flymake . nil)
    (lsp-print-performance . t)
    :config
    (define-key lsp-ui-mode-map [remap xref-find-definitions] 'lsp-ui-peek-find-definitions)
    (define-key lsp-ui-mode-map [remap xref-find-references] 'lsp-ui-peek-find-references)
    (define-key lsp-ui-mode-map (kbd "C-c i") 'lsp-ui-imenu)
    (define-key lsp-ui-mode-map (kbd "s-l") 'hydra-lsp/body)
    (setq lsp-ui-doc-position 'bottom)
    :hydra (hydra-lsp (:exit t :hint nil)
                      "
 Buffer^^               Server^^                   Symbol
-------------------------------------------------------------------------------------
 [_f_] format           [_M-r_] restart            [_d_] declaration  [_i_] implementation  [_o_] documentation
 [_m_] imenu            [_S_]   shutdown           [_D_] definition   [_t_] type            [_r_] rename
 [_x_] execute action   [_M-s_] describe session   [_R_] references   [_s_] signature"
                      ("d" lsp-find-declaration)
                      ("D" lsp-ui-peek-find-definitions)
                      ("R" lsp-ui-peek-find-references)
                      ("i" lsp-ui-peek-find-implementation)
                      ("t" lsp-find-type-definition)
                      ("s" lsp-signature-help)
                      ("o" lsp-describe-thing-at-point)
                      ("r" lsp-rename)

                      ("f" lsp-format-buffer)
                      ("m" lsp-ui-imenu)
                      ("x" lsp-execute-code-action)

                      ("M-s" lsp-describe-session)
                      ("M-r" lsp-restart-workspace)
                      ("S" lsp-shutdown-workspace))
    )
  )

(leaf terraform-mode
  :ensure t
  :mode "\\.tf\\'" "\\.hcl\\'"
  :init
  (add-hook 'terraform-mode-hook 'terraform-format-on-save-mode)
  (add-hook 'terraform-mode-hook 'hs-minor-mode)
  :hook (terraform-mode-hook . lsp-deferred)
  )

(leaf golang
  :config
  (leaf go-mode
    :ensure t
    :leaf-defer t
    :commands (gofmt-before-save)
    :init
    (add-hook 'before-save-hook 'gofmt-before-save)
    (setq tab-width 4)
    :hook
    (go-mode . (lambda ()
                 (hs-minor-mode 1))))
  (leaf protobuf-mode
    :ensure t)
  (leaf go-impl
    :ensure t
    :leaf-defer t
    :commands go-impl)
  )

;;; web-mode
;; Web modeの設定
(leaf web-mode
  :ensure t
  :mode (("\\.phtml\\'" . web-mode)
         ("\\.tpl\\.php\\'" . web-mode)
         ("\\.[gj]sp\\'" . web-mode)
         ("\\.as[cp]x\\'" . web-mode)
         ("\\.erb\\'" . web-mode)
         ("\\.mustache\\'" . web-mode)
         ("\\.djhtml\\'" . web-mode)
         ("\\.html?\\'" . web-mode)
         ("\\.js\\'" . web-mode)
         ("\\.ts\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         )
  :custom
  (web-mode-engines-alist . '(("php"    . "\\.phtml\\'")
                              ("blade"  . "\\.blade\\.")))
  (web-mode-enable-current-element-highlight . t)
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-comment-style 2
        web-mode-style-padding 1
        web-mode-script-padding 1)
  (setq web-mode-attr-indent-offset nil)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-auto-close-style 2)
  (setq web-mode-tag-auto-close-style 2)
  (setq indent-tabs-mode nil)
  (setq tab-width 2)
  )


(leaf tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save))
  )

;; GraphQL mode
(leaf graphql-mode
  :ensure t
  :mode ("\\.graphql\\'" "\\.gql\\'")
  :custom
  (graphql-indent-level . 2))

;; Prisma Mode
(use-package prisma-mode
  :vc (
       :url "https://github.com/pimeys/emacs-prisma-mode"
            :rev
            :newest))

;; py-isort
(leaf py-isort :ensure t)

;; python
(leaf elpy
  :ensure t
  :init
  (elpy-enable)
  :config
  (remove-hook 'elpy-modules 'elpy-module-highlight-indentation)
  (remove-hook 'elpy-modules 'elpy-module-flymake)
  :init
  (setq tab-width 2)
  :custom
  (elpy-rpc-python-command . "python3")
  (flycheck-python-flake8-executable . "flake8")
  :bind (elpy-mode-map
         ("C-c C-r f" . elpy-format-code))
  :hook (
         (elpy-mode-hook . flycheck-mode)
         )
  )

(add-hook 'python-mode-hook #'flycheck-mode)

(leaf ruby-mode
  ;; :mode "\\.rb\\"
  )

;; yamlの設定
(leaf yaml-mode
 :ensure t
 :leaf-defer t
 )

(leaf dockerfile-mode
  :ensure t
  :mode (("Dockerfile" . dockerfile-mode)))


(leaf json-mode
  :package t
  :mode (("\\.json\\'" . json-mode))
  :hook ((json-mode-hook . my-json-mode-initialize))
  :init
  (defun my-json-mode-initialize ()
    "Initialize `json-mode' before file load."
    (setq-local indent-tabs-mode nil)
    (setq-local tab-width 2)
    (setq-local js-indent-level tab-width)

    ))



;; markdown
(leaf markdown
  :config
  (leaf markdown-mode
    :ensure t
    :leaf-defer t
    :mode ("\\.md\\'" . gfm-mode)
    :custom
    (markdown-command . "github-markup")
    (markdown-command-needs-filename . t))
  (leaf markdown-preview-mode
    :ensure t))


(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(tea-time terraform-mode evil ddskk auto-async-byte-compile lispxmp open-junk-file paredit blackout el-get hydra leaf-keywords leaf)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
(put 'erase-buffer 'disabled nil)
