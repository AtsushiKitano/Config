(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
	  (expand-file-name
	   (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
	                   ("melpa" . "https://melpa.org/packages/")
	                   ("org"   . "https://orgmode.org/elpa/")))
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
	(leaf-keywords-init)))

;; ここにいっぱい設定を書く(
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
      '(misc-info persp-name lsp github debug minor-modes input-method major-mode process vcs checker))
    )
    ;; Hide mode line
  ;; 特定のモードでモードラインを非表示にする
  (leaf hide-mode-line
    :ensure t neotree minimap imenu-list
    :hook
    ((neotree-mode imenu-list-minor-mode minimap-mode) . hide-mode-line-mode)
    )
  )


(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))

;; 全体設定
(leaf general-setting
  :config
  (define-key global-map (kbd "C-{") 'hs-hide-block)
  (define-key global-map (kbd "C-}") 'hs-show-block)
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
    (read-process-output-max               . ,(* 1024 1024)))
  :setq-default
  (indent-tabs-mode . nil) ; タブはスペースで
  (tab-width        . 4)
  (require-final-newline . t)
  )

(leaf smartparens
  :ensure t
  :hook (after-init-hook . smartparens-global-strict-mode) ; strictモードを有効化
  :require smartparens-config
  :custom ((electric-pair-mode . nil)))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

(leaf line-number-mode
  :custom
  ((linum-format . "%5d"))
  (line-number-mode . nil)
  )

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf cus-start
  :doc "define customization properties of builtins"
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
            (menu-bar-mode . nil)
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
  :emacs>= 24.3
  :ensure t
  :hook (prog-mode-hook . flycheck-mode)
  :custom ((flycheck-display-errors-delay . 0.3))
  :config
  (leaf flycheck-inline
    :ensure t
    :hook (flycheck-mode-hook . flycheck-inline-mode))
  (leaf flycheck-color-mode-line
    :ensure t
    :hook (flycheck-mode-hook . flycheck-color-mode-line-mode))
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode)

(leaf company
  :doc "Modular text completion framework"
  :req "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :url "http://company-mode.github.io/"
  :emacs>= 24.3
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
  :req "emacs-24.1" "company-0.8"
  :tag "company" "development" "emacs>=24.1"
  :added "2020-03-25"
  :emacs>= 24.1
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
            ("M-[" . previous-multiframe-window)
            ("M-]" . next-multiframe-window)
            ("M-z" . delete-other-windows)))

(leaf electric
  :doc "window maker and command loop for `electric' modes"
  :tag "builtin"
  :added "2022-04-24"
  :init (electric-pair-mode 1))


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
  :req "git-gutter-0.88" "fringe-helper-0.1.1" "cl-lib-0.5" "emacs-24"
  :tag "emacs>=24"
  :url "https://github.com/emacsorphanage/git-gutter-fringe"
  :added "2022-10-10"
  :emacs>= 24
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
   ("C-x j"   . skk-mode))
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

(leaf terraform-mode
  :ensure t
  :mode "\\.tf\\'" "\\.pkr.hcl\\'"
  :init
  (add-hook 'terraform-mode-hook 'terraform-format-on-save-mode)
  (add-hook 'terraform-mode-hook 'hs-minor-mode)
  )

(leaf lsp-mode
  :ensure t
  :require t
  :commands lsp
  :hook
  (go-mode-hook . lsp)
  (web-mode-hook . lsp)
  ;; (typescript-mode-hook . lsp)
  :config
  (leaf lsp-ui
    :ensure t
    :require t
    :hook
    (lsp-mode-hook . lsp-ui-mode)
    :custom
    (lsp-ui-sideline-enable . nil)
    (lsp-prefer-flymake . nil)
    (lsp-print-performance . t)
    )
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
         )
  :custom
  (web-mode-engines-alist . '(("php"    . "\\.phtml\\'")
                              ("blade"  . "\\.blade\\.")))
  (web-mode-enable-current-element-highlight . t)
  )

(leaf tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

;; typescript
(leaf typescript-mode
  :doc "Major mode for editing typescript"
  :req "emacs-24.3"
  :tag "languages" "typescript" "emacs>=24.3"
  :url "http://github.com/ananthakumaran/typescript.el"
  :added "2022-10-10"
  :emacs>= 24.3
  :ensure t
  :mode "\\.ts\\'" "\\.tsx\\'"
  :hook
  (typescript-mode-hook . (lambda ()
                            (interactive)
                            (flycheck-mode +1)
                            (company-mode +1)
                            (eldoc-mode +1)
                            ))
  :custom
  (typescript-indent-level . 2)
  )

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
  ;; ;; Workaround of not working counsel-yank-pop
  ;; ;; https://github.com/akermu/emacs-libvterm#counsel-yank-pop-doesnt-work
  ;; (defun my/vterm-counsel-yank-pop-action (orig-fun &rest args)
  ;;   (if (equal major-mode 'vterm-mode)
  ;;       (let ((inhibit-read-only t)
  ;;             (yank-undo-function (lambda (_start _end) (vterm-undo))))
  ;;         (cl-letf (((symbol-function 'insert-for-yank)
  ;;                    (lambda (str) (vterm-send-string str t))))
  ;;           (apply orig-fun args)))
  ;;     (apply orig-fun args)))
  ;; (advice-add 'counsel-yank-pop-action :around #'my/vterm-counsel-yank-pop-action)
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

;; python
(leaf elpy
  :ensure t
  :defun
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
  :hook ((elpy-mode-hook . flycheck-mode)))

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

;; インデントの表示
(leaf highlight-indent-guides
  :ensure t
  :blackout t
  :hook
  (((prog-mode-hook yaml-mode-hook) . highlight-indent-guides-mode))
  :custom (
           (highlight-indent-guides-method . 'character)
           (highlight-indent-guides-auto-enabled . t)
           (highlight-indent-guides-responsive . t)
           (highlight-indent-guides-character . ?\|)           
           ))

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

    ;; EditorConfig 対応
    ;; (with-eval-after-load 'editorconfig
    ;;   (if (hash-table-p editorconfig-properties-hash)
    ;;       (let* ((indent-style-data (gethash 'indent_style editorconfig-properties-hash))
    ;;              (indent-style (equal indent-style-data "tab"))
    ;;              (tab-width-number-data (gethash 'tab_width editorconfig-properties-hash))
    ;;              (tab-width-number (if (and tab-width-number-data
    ;;                                         (stringp tab-width-number-data))
    ;;                                    (string-to-number tab-width-number-data)
    ;;                                  tab-width)))
    ;;         (if (not (equal indent-tabs-mode indent-style))
    ;;             (setq-local indent-tabs-mode indent-style))
    ;;         (if (not (equal tab-width tab-width-number))
    ;;             (setq-local tab-width tab-width-number))
    ;;         (if (not (equal js-indent-level tab-width))
    ;;             (setq-local js-indent-level tab-width)))))
    ))

;; (leaf volatile-highlights
;;              :diminish
;;              :hook
;;              (after-init . volatile-highlights-mode)
;;              :custom-face
;;              (vhl/default-face ((nil (:foreground "#FF3333" :background "#FFCDCD")))))

;; org mode


 ;; (leaf markdown
 ;;  :config
 ;;  (leaf markdown-mode
 ;;    :ensure t
 ;;    :leaf-defer t
 ;;    :mode ("\\.md\\" .gfm-mode)
 ;;    :custom
 ;;    (markdown-command . "github-markup")
 ;;    (markdown-command-needs-filename . t))
 ;;  (leaf markdown-preview-mode
 ;;  :ensure t))

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
