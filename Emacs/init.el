;;; init.el --- Emacs configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;; native compiler の非同期警告を抑制（ddskk/ccc 等の無害な警告対策）
(setq native-comp-async-report-warnings-errors 'silent)

;;; ========================================================
;;; exec-path / PATH
;;; ========================================================

(add-to-list 'exec-path (expand-file-name "~/dev/src/github/bin"))
(setenv "PATH" (concat (getenv "PATH") ":" (expand-file-name "~/dev/src/github/bin")))

(leaf exec-path-from-shell
  :ensure t
  :require t
  :config
  (exec-path-from-shell-initialize))

;;; ========================================================
;;; user-emacs-directory
;;; ========================================================

(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

;;; ========================================================
;;; パッケージ管理 (leaf)
;;; ========================================================

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"    . "https://elpa.gnu.org/packages/")
                       ("melpa"  . "https://melpa.org/packages/")
                       ("org"    . "https://orgmode.org/elpa/")
                       ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    (leaf hydra    :ensure t)
    (leaf el-get   :ensure t)
    (leaf blackout :ensure t)
    :config
    (leaf-keywords-init)))

(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size     . 30)
             (imenu-list-position . 'left))))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

;;; ========================================================
;;; 一般設定
;;; ========================================================

(setq mac-command-modifier      'meta)
(setq mac-option-key-is-meta    nil)
(setq ns-right-alternate-modifier nil)

(setq default-frame-alist
      (append '((alpha . 85)) default-frame-alist))
(setq initial-frame-alist default-frame-alist)

(leaf cus-start
  :doc "起動時の設定"
  :tag "builtin" "internal"
  :preface
  (defun c/redraw-frame nil
    (interactive)
    (redraw-frame))
  :bind (("M-ESC ESC" . c/redraw-frame))
  :custom '((user-full-name                  . "Atsushi Kitano")
            (user-mail-address               . "atsushi@aquamarine-cloud.net")
            (user-login-name                 . "atsushi")
            (fill-column                     . 72)
            (create-lockfiles                . nil)
            (debug-on-error                  . nil)
            (init-file-debug                 . nil)
            (frame-resize-pixelwise          . t)
            (enable-recursive-minibuffers    . t)
            (history-length                  . 1000)
            (history-delete-duplicates       . t)
            (scroll-preserve-screen-position . t)
            (scroll-conservatively           . 100)
            (mouse-wheel-scroll-amount       . '(1 ((control) . 5)))
            (ring-bell-function              . 'ignore)
            (text-quoting-style              . 'straight)
            (truncate-lines                  . t)
            (use-dialog-box                  . nil)
            (use-file-dialog                 . nil)
            (menu-bar-mode                   . -1)
            (tool-bar-mode                   . -1)
            (scroll-bar-mode                 . -1)
            (indent-tabs-mode                . nil)
            (auto-save-default               . t)
            (auto-save-timeout               . 15)
            (auto-save-interval              . 60)
            (make-backup-files               . t)
            (backup-by-copying               . t))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p))

(leaf general-setting
  :config
  (define-key global-map (kbd "C-{") 'hs-hide-block)
  (define-key global-map (kbd "C-}") 'hs-show-block)
  (define-key global-map [?¥] [?\\])
  (prefer-coding-system 'utf-8-unix)
  (defvar recentf-max-saved-items 1000)
  (defvar recentf-auto-cleanup 'never)
  ;; フォント
  (add-to-list 'default-frame-alist '(font . "Monospace-18"))
  ;; リージョンの色
  (set-face-attribute 'region nil :background "#ca6500")
  ;; マウスを避けさせる
  (mouse-avoidance-mode 'jump)
  (setq frame-title-format "%f")
  ;; 行番号
  (global-display-line-numbers-mode t)
  (set-face-attribute 'line-number-current-line nil :foreground "gold")
  ;; 括弧ハイライト
  (show-paren-mode t)
  (defvar show-paren-style 'mixed)
  ;; カーソル点滅なし
  (blink-cursor-mode 0)
  ;; 単語での折り返し
  (leaf visual-line-mode
    :require simple
    :config
    (global-visual-line-mode t))
  :setq
  `((large-file-warning-threshold  . ,(* 25 1024 1024))
    (read-file-name-completion-ignore-case . t)
    (line-move-visual               . nil)
    (mouse-drag-copy-region         . t)
    (inhibit-startup-message        . t)
    (require-final-newline          . t)
    (next-line-add-newlines         . nil)
    (truncate-lines                 . t)
    (read-process-output-max        . ,(* 1024 1024)))
  :setq-default
  (indent-tabs-mode      . nil)
  (tab-width             . 2)
  (require-final-newline . t))

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
  :custom ((kill-ring-max                . 100)
           (kill-read-only-ok            . t)
           (kill-whole-line              . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level  . nil)))

(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-timeout             . 15)
            (auto-save-interval            . 60)
            (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist        . '((".*" . ,(locate-user-emacs-file "backup"))
                                               (,tramp-file-name-regexp . nil)))
            (version-control               . t)
            (delete-old-versions           . t)))

(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

(leaf electric
  :doc "electric modes"
  :tag "builtin"
  :config (electric-pair-mode 0))

;;; ========================================================
;;; UI / テーマ
;;; ========================================================

(leaf doom-themes
  :ensure t
  :custom
  (doom-themes-enable-italic . nil)
  (doom-themes-enable-bold   . nil)
  :config
  (load-theme 'doom-tomorrow-night t)
  (doom-themes-org-config))

(leaf mood-line
  :ensure t
  :config
  (mood-line-mode))

(leaf all-the-icons
  :ensure t
  :init (leaf memoize :ensure t)
  :require t)

(leaf imenu
  :tag "builtin"
  :custom
  (imenu-auto-rescan . t))

(leaf imenu-list
  :ensure t
  :custom
  ((imenu-list-auto-resize           . nil)
   (imenu-list-focus-after-activation . nil)
   (imenu-list-position              . 'left))
  :hook
  (imenu-list-major-mode-hook . (lambda ()
                                  (setq mode-line-format nil)
                                  (display-line-numbers-mode 0))))

(leaf hide-mode-line
  :ensure t
  :hook
  ((imenu-list-minor-mode) . hide-mode-line-mode))

;;; ========================================================
;;; グローバルキーバインド
;;; ========================================================

(leaf-keys (("C-h" . backward-delete-char)
            ("M-h" . previous-multiframe-window)
            ("M-l" . next-multiframe-window)
            ("M-z" . delete-other-windows)))

(leaf mwim
  :ensure t
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)))

;;; ========================================================
;;; Evil モード
;;; ========================================================

(leaf evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  ;; 特定モードで emacs state を初期状態に
  (with-eval-after-load 'evil
    (dolist (mode '(dired-mode
                    magit-mode
                    imenu-list-major-mode))
      (evil-set-initial-state mode 'emacs)))
  ;; 挿入モードでも Emacs キーバインドを使う
  (defun my/kill-region-or-backward-kill-word ()
    "リージョンがアクティブなら kill-region、そうでなければ backward-kill-word。"
    (interactive)
    (if (use-region-p)
        (kill-region (region-beginning) (region-end))
      (backward-kill-word 1)))
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
    (define-key map (kbd "C-w") 'my/kill-region-or-backward-kill-word)
    (define-key map (kbd "C-y") 'yank)
    (define-key map (kbd "M-d") 'kill-word)
    (define-key map (kbd "C-g") 'evil-normal-state)
    (define-key map (kbd "C-v") 'scroll-up)
    (define-key map (kbd "M-v") 'scroll-down))
  ;; visual state で C-w → kill-region
  (define-key evil-visual-state-map (kbd "C-w") 'kill-region))

(declare-function evil-set-initial-state "evil")

;;; ========================================================
;;; 括弧管理 (smartparens)
;;; ========================================================

(leaf smartparens
  :ensure t
  :require smartparens-config
  :bind (("C-M-a" . sp-beginning-of-sexp)
         ("C-M-e" . sp-end-of-sexp)
         ("C-M-d" . sp-down-sexp)
         ("C-M-u" . sp-up-sexp)
         ("C-M-w" . sp-backward-down-sexp)
         ("C-M-q" . sp-backward-up-sexp)
         ("C-M-f" . sp-forward-symbol)
         ("C-M-b" . sp-backward-symbol)
         ("C-M-n" . sp-next-sexp)
         ("C-M-p" . sp-previous-sexp)
         ("C-s-f" . sp-forward-sexp)
         ("C-s-b" . sp-backward-sexp)
         ("C-c ("  . wrap-with-parens)
         ("C-c ["  . wrap-with-brackets)
         ("C-c {"  . wrap-with-braces)
         ("C-c \""  . wrap-with-double-quotes)
         ("M-]"   . sp-unwrap-sexp)
         ("M-k"   . sp-kill-sexp))
  :init
  (smartparens-global-mode t)
  :custom
  (electric-pair-mode . nil)
  :config
  (require 'smartparens-config)
  ;; Go: { 後の改行でインデント
  (sp-with-modes '(go-mode go-ts-mode)
    (sp-local-pair "{" nil :post-handlers '(:add "||\n[i]")))
  ;; TSX/JSX: { 後スペース挿入、< > ペア有効
  (sp-with-modes '(web-mode typescript-mode tsx-ts-mode typescript-ts-mode)
    (sp-local-pair "{" nil :post-handlers '(:add "| "))
    (sp-local-pair "<" ">"))
  (sp-pair "'" nil :unless '(sp-point-after-word-p)))

(declare-function sp-pair "smartparens")
(declare-function sp-local-pair "smartparens")
(declare-function sp-with-modes "smartparens")

;;; ========================================================
;;; 日本語入力 (ddskk)
;;; ========================================================

(leaf ddskk
  :ensure t
  :bind
  (("C-x C-j" . skk-mode)
   ("M-j"     . skk-mode))
  :init
  (defvar dired-bind-jump nil)
  :custom
  (skk-use-azik                       . t)
  (skk-azik-keyboard-type             . 'jp106)
  (skk-preload                        . t)
  (skk-byte-compile-init-file         . t)
  (skk-indicator-use-cursor-color     . nil)
  (skk-indicator-prefix               . "")
  (skk-egg-like-newline               . t)
  (skk-show-annotation                . nil)
  (skk-undo-kakutei-word-only         . t)
  (skk-henkan-strict-okuri-precedence . t)
  (default-input-method               . "japanese-skk")
  (skk-show-inline                    . t)
  (skk-use-look                       . t))

;;; ========================================================
;;; 補完フレームワーク（vertico + consult + corfu + orderless）
;;; ========================================================

(leaf vertico
  :ensure t
  :global-minor-mode vertico-mode
  :config
  (with-eval-after-load 'vertico
    (define-key vertico-map (kbd "C-h") #'backward-delete-char)))

(leaf orderless
  :ensure t
  :custom
  (completion-styles             . '(orderless basic))
  (completion-category-overrides . '((file (styles basic partial-completion)))))

(leaf marginalia
  :ensure t
  :global-minor-mode marginalia-mode)

(leaf consult
  :ensure t
  :bind (("C-s"     . consult-line)
         ("C-x C-r" . consult-recent-file)
         ("C-S-s"   . consult-imenu)
         ("C-x b"   . consult-buffer)
         ("M-y"     . consult-yank-pop))
  :custom
  (consult-async-min-input . 2))

(leaf corfu
  :ensure t
  :custom
  (corfu-auto        . t)
  (corfu-auto-delay  . 0)
  (corfu-auto-prefix . 1)
  (corfu-cycle       . t)
  :bind (:corfu-map
         ("C-n"   . corfu-next)
         ("C-p"   . corfu-previous)
         ("<tab>" . corfu-complete))
  :global-minor-mode global-corfu-mode)

(leaf cape
  :ensure t
  :config
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

;;; ========================================================
;;; スニペット (yasnippet)
;;; ========================================================

(leaf yasnippet
  :ensure t
  :blackout yas-minor-mode
  :custom ((yas-indent-line . 'fixed)
           (yas-global-mode . t))
  :bind ((yas-keymap
          ("<tab>" . nil))
         (yas-minor-mode-map
          ("C-c y i" . yas-insert-snippet)
          ("C-c y n" . yas-new-snippet)
          ("C-c y v" . yas-visit-snippet-file)
          ("C-c y l" . yas-describe-tables)
          ("C-c y g" . yas-reload-all)))
  :config
  (leaf yasnippet-snippets :ensure t)
  (leaf yatemplate
    :commands (yatemplate-fill-alist)
    :ensure t
    :config
    (yatemplate-fill-alist)))

;;; ========================================================
;;; 文法チェック (flycheck)
;;; ========================================================

(leaf flycheck
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
  (unless (display-graphic-p)
    (remove-hook 'flycheck-mode-hook #'flycheck-inline-mode)
    (setq flycheck-inline-mode nil)
    (setq flycheck-display-errors-function #'flycheck-display-error-messages)
    (setq flycheck-display-errors-delay 0.1))
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode)

;;; ========================================================
;;; LSP (lsp-mode)
;;; ========================================================

(leaf lsp-mode
  :ensure t
  :require t
  :commands lsp
  :hook
  ((go-ts-mode-hook         . lsp-deferred)
   (typescript-ts-mode-hook . lsp-deferred)
   (tsx-ts-mode-hook        . lsp-deferred)
   (web-mode-hook           . lsp-deferred)
   (terraform-mode-hook     . lsp-deferred))
  :custom ((lsp-keymap-prefix               . "C-c l")
           (lsp-completion-provider         . :capf)
           (lsp-idle-delay                  . 0.5)
           (lsp-prefer-capf                 . t)
           (lsp-ui-doc-enable               . t)
           (lsp-ui-doc-position             . 'at-point)
           (lsp-go-analyses                 . '((unusedparams . t)
                                                (unusedwrite  . t)))
           (lsp-completion-show-detail      . t)
           (lsp-completion-show-kind        . t)
           (lsp-headerline-breadcrumb-enable . t))
  :config
  (setq lsp-disabled-clients '(tfls))
  (setq lsp-register-custom-settings
        '(("gopls" (("completeUnimported" . t)
                    ("usePlaceholders"    . t)
                    ("deepCompletion"     . t)
                    ("hoverKind"          . "FullDocumentation")))))

  (leaf lsp-ui
    :ensure t
    :require t
    :hook (lsp-mode-hook . lsp-ui-mode)
    :custom
    (lsp-ui-sideline-enable . nil)
    (lsp-prefer-flymake     . nil)
    (lsp-print-performance  . t)
    :config
    (define-key lsp-ui-mode-map [remap xref-find-definitions] 'lsp-ui-peek-find-definitions)
    (define-key lsp-ui-mode-map [remap xref-find-references]  'lsp-ui-peek-find-references)
    (define-key lsp-ui-mode-map (kbd "C-c i") 'lsp-ui-imenu)
    (define-key lsp-ui-mode-map (kbd "s-l")   'hydra-lsp/body)
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
                      ("S" lsp-shutdown-workspace))))

(declare-function lsp-organize-imports "lsp")

(leaf lsp-treemacs
  :ensure t
  :after lsp-mode
  :commands lsp-treemacs-errors-list)

;;; ========================================================
;;; TreeSitter
;;; ========================================================

(leaf treesit-auto
  :ensure t
  :custom
  (treesit-auto-install . 'prompt)
  :config
  (when (fboundp 'global-treesit-auto-mode)
    (global-treesit-auto-mode)))

;;; ========================================================
;;; Git 管理
;;; ========================================================

(leaf magit
  :ensure t
  :bind (("C-x g"   . magit-status)
         ("C-x M-g" . magit-dispatch)))

(leaf git-gutter-fringe
  :ensure t
  :custom ((git-gutter:lighter     . "")
           (global-git-gutter-mode . t)))

;;; ========================================================
;;; ターミナル
;;; ========================================================

;; eat（メイン）
(leaf eat
  :ensure t
  :bind (("C-c t" . eat))
  :custom
  (eat-kill-buffer-on-exit . t)
  (eat-enable-mouse        . t)
  :config
  (with-eval-after-load 'eat
    (define-key eat-mode-map (kbd "C-h") (lambda ()
                                           (interactive)
                                           (eat-self-input 1 ?\177))))
  (with-eval-after-load 'evil
    (evil-set-initial-state 'eat-mode 'emacs))
  :hook (eat-mode-hook . (lambda ()
                           (setq-local inhibit-read-only t)
                           (setq-local scroll-margin 0)
                           (display-line-numbers-mode -1)
                           (when (fboundp 'evil-emacs-state)
                             (evil-emacs-state)))))

;; vterm（補助）
(leaf vterm
  :ensure t
  :bind (("M-t" . vterm))
  :custom
  (vterm-max-scrollback         . 10000)
  (vterm-buffer-name-string     . "vterm: %s")
  (vterm-install-static-modules . t)
  :config
  (with-eval-after-load 'vterm
    (add-to-list 'vterm-keymap-exceptions "M-j")
    (define-key vterm-mode-map (kbd "C-m")      #'vterm-send-return)
    (define-key vterm-mode-map (kbd "RET")      #'vterm-send-return)
    (define-key vterm-mode-map (kbd "<return>") #'vterm-send-return)
    (define-key vterm-mode-map (kbd "C-h")      #'vterm-send-backspace))
  :hook (vterm-mode-hook . (lambda ()
                             (setq-local scroll-margin 0)
                             (display-line-numbers-mode -1)
                             (setq-local skk-egg-like-newline nil)
                             (setq inhibit-read-only t)
                             (read-only-mode -1)
                             (smartparens-mode -1)
                             (when (fboundp 'evil-emacs-state)
                               (evil-emacs-state)))))

(leaf vterm-toggle
  :ensure t
  :custom
  (vterm-toggle-scope . 'project)
  :config
  (add-to-list 'display-buffer-alist
               '((lambda (bufname _)
                   (with-current-buffer bufname
                     (equal major-mode 'vterm-mode)))
                 (display-buffer-reuse-window display-buffer-in-direction)
                 (direction       . bottom)
                 (reusable-frames . visible)
                 (window-height   . 0.4))))

;;; ========================================================
;;; UI 補助
;;; ========================================================

(leaf rainbow-delimiters
  :ensure t
  :hook
  ((prog-mode-hook . rainbow-delimiters-mode)))

(leaf whitespace
  :ensure t
  :commands whitespace-mode
  :bind ("C-c W" . whitespace-cleanup)
  :custom ((whitespace-style            . '(face trailing tabs spaces empty space-mark tab-mark))
           (whitespace-display-mappings . '((space-mark ?\u3000 [?\u25a1])
                                            (tab-mark   ?\t     [?\u00BB ?\t] [?\\ ?\t])))
           (whitespace-space-regexp     . "\\(\u3000+\\)")
           (whitespace-global-modes     . '(emacs-lisp-mode shell-script-mode sh-mode python-mode org-mode))
           (global-whitespace-mode      . t))
  :config
  (set-face-attribute 'whitespace-trailing nil :background "Black" :foreground "DeepPink"    :underline t)
  (set-face-attribute 'whitespace-tab      nil :background "Black" :foreground "LightSkyBlue" :underline t)
  (set-face-attribute 'whitespace-space    nil :background "Black" :foreground "GreenYellow"  :weight 'bold)
  (set-face-attribute 'whitespace-empty    nil :background "Black"))

;;; ========================================================
;;; コードフォーマット (reformatter)
;;; ========================================================

(leaf reformatter
  :ensure t
  :require t
  :config
  (reformatter-define go-format
    :program "goimports")
  (reformatter-define web-format
    :program "npx"
    :args `("prettier" "--stdin-filepath" ,buffer-file-name "--tab-width" "2"))
  (reformatter-define python-format
    :program "ruff"
    :args `("format" "--stdin-filename" ,buffer-file-name))
  :hook
  (go-ts-mode-hook          . go-format-on-save-mode)
  (tsx-ts-mode-hook         . web-format-on-save-mode)
  (typescript-ts-mode-hook  . web-format-on-save-mode)
  (json-ts-mode-hook   . web-format-on-save-mode)
  (graphql-mode-hook   . web-format-on-save-mode)
  (prisma-mode-hook    . web-format-on-save-mode)
  (python-ts-mode-hook . python-format-on-save-mode))

(declare-function web-format-region "reformatter")
(declare-function web-format-on-save-mode "reformatter")
(declare-function go-format-region "reformatter")

;;; ========================================================
;;; プログラミング言語
;;; ========================================================

;;; --- Go ---

(with-eval-after-load 'go-ts-mode
  (setq-local tab-width       4)
  (setq-local indent-tabs-mode t))

(add-hook 'go-ts-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'lsp-organize-imports t t)))

;;; --- TypeScript / TSX ---
;; treesit-auto が typescript-mode → typescript-ts-mode / tsx-ts-mode へ自動マッピング

;;; --- Web ---

(leaf web-mode
  :ensure t
  :mode (("\\.phtml\\'"    . web-mode)
         ("\\.tpl\\.php\\'" . web-mode)
         ("\\.[gj]sp\\'"   . web-mode)
         ("\\.as[cp]x\\'"  . web-mode)
         ("\\.erb\\'"      . web-mode)
         ("\\.mustache\\'" . web-mode)
         ("\\.djhtml\\'"   . web-mode)
         ("\\.html?\\'"    . web-mode))
  :custom
  (web-mode-engines-alist                    . '(("php"   . "\\.phtml\\'")
                                                 ("blade" . "\\.blade\\.")))
  (web-mode-enable-current-element-highlight . t)
  (web-mode-markup-indent-offset             . 2)
  (web-mode-code-indent-offset               . 2)
  :config
  (setq web-mode-css-indent-offset    2
        web-mode-comment-style        2
        web-mode-style-padding        1
        web-mode-script-padding       1
        web-mode-attr-indent-offset   nil
        web-mode-enable-auto-closing  t
        web-mode-enable-auto-pairing  t
        web-mode-auto-close-style     2
        web-mode-tag-auto-close-style 2
        indent-tabs-mode              nil))

;;; --- Python ---

(leaf lsp-pyright
  :ensure t
  :after lsp-mode
  :custom ((lsp-pyright-multi-root . nil))
  :hook (python-ts-mode-hook . (lambda ()
                                 (require 'lsp-pyright)
                                 (lsp-deferred))))

(leaf pyvenv
  :ensure t
  :config
  (pyvenv-mode 1))

(leaf blacken
  :ensure t
  :hook (python-ts-mode-hook . blacken-mode)
  :custom ((blacken-line-length               . 119)
           (blacken-skip-string-normalization . t)))

;;; --- Terraform ---

(leaf terraform-mode
  :ensure t
  :mode "\\.tf\\'" "\\.hcl\\'"
  :init
  (add-hook 'terraform-mode-hook 'terraform-format-on-save-mode)
  (add-hook 'terraform-mode-hook 'hs-minor-mode))

;;; --- GraphQL ---

(leaf graphql-mode
  :ensure t
  :mode ("\\.graphql\\'" "\\.gql\\'")
  :custom
  (graphql-indent-level . 2))

;;; --- Prisma ---

(use-package prisma-mode
  :vc (:url "https://github.com/pimeys/emacs-prisma-mode" :rev :newest))

;;; --- YAML ---

(leaf yaml-mode
  :ensure t
  :leaf-defer t)

;;; --- Dockerfile ---

(leaf dockerfile-mode
  :ensure t
  :mode (("Dockerfile" . dockerfile-mode)))

;;; --- JSON ---

(leaf json-mode
  :package t
  :mode (("\\.json\\'" . json-mode))
  :hook ((json-mode-hook . my-json-mode-initialize))
  :init
  (defun my-json-mode-initialize ()
    (setq-local indent-tabs-mode nil)
    (setq-local tab-width        2)
    (setq-local js-indent-level  tab-width)))

;;; --- Markdown ---

(leaf markdown
  :config
  (leaf markdown-mode
    :ensure t
    :leaf-defer t
    :mode ("\\.md\\'" . gfm-mode)
    :custom
    (markdown-command              . "github-markup")
    (markdown-command-needs-filename . t))
  (leaf markdown-preview-mode
    :ensure t))

;;; ========================================================
;;; Claude Code IDE
;;; ========================================================

(leaf claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup))

;;; ========================================================

(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(terraform-mode evil ddskk blackout el-get hydra leaf-keywords leaf)))
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
