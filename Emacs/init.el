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
; 背景
(set-face-background 'default "#333333")
(set-face-foreground 'default "#32cd32")
(add-to-list 'default-frame-alist
             '(alpha . (0.85 0.85)))
(add-to-list 'default-frame-alist
             '(font . "Monospace-18"))


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
            (menu-bar-mode . t)
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


;; (leaf cc-mode
;;   :doc "major mode for editing C and similar languages"
;;   :tag "builtin"
;;   :defvar (c-basic-offset)
;;   :bind (c-mode-base-map
;;          ("C-c c" . compile))
;;   :mode-hook
;;   (c-mode-hook . ((c-set-style "bsd")
;;                   (setq c-basic-offset 4)))
;;   (c++-mode-hook . ((c-set-style "bsd")
;;                     (setq c-basic-offset 4))))

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
    :global-minor-mode t))

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
  (imenu-list-major-mode-hook . (lambda ()
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

(leaf magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-popup)))

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

(leaf terraform-mode
  :ensure t
  :init
  (add-hook 'terraform-mode-hook 'terraform-format-on-save-mode))

(leaf lsp-mode
  :ensure t
  :require t
  :commands lsp
  :hook
  (go-mode-hook . lsp)
  (web-mode-hook . lsp)
  (typescript-mode-hook . lsp)
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
    (setq tab-width 4))
  
  (leaf protobuf-mode
    :ensure t)

  (leaf go-impl
    :ensure t
    :leaf-defer t
    :commands go-impl)
  )

;; (leaf web-mode
;;   :ensure t
;;   :after flycheck
;;   :defun flycheck-add-mode
;;   :mode (
;;          ("\\.html?\\" . web-mode)
;;          ("\\.scss\\" . web-mode)
;;          ("\\.css\\" . web-mode)
;;          ("\\.twing\\" . web-mode)
;;          ("\\.vue\\" . web-mode)
;;          ("\\.js\\" . web-mode))
;;   :config
;;   (flycheck-add-mode 'javascript-eslint 'web-mode)
;;   (setq web-mode-markup-indent-offset 2
;;         web-mode-css-indent-offset 2
;;         web-mode-code-indent-offset 2
;;         web-mode-comment-style 2
;;         web-mode-style-padding 1
;;         web-mode-script-padding 1)
;;   )

;; (leaf emmet-mode
;;   :ensure t
;;   :leaf-defer t
;;   :commands (emment-mode)
;;   :hook
;;   (web-mode-hook.emmet-mode))

(leaf typescript-mode
  :ensure t
  :custom
  (typescript-indent-level . 2)
  )

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
  ;; :config
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

;; (leaf projectile
;;   :ensure t counsel-projectile
;;   :require t
;;   :config
;;   (projectile-mode +1)
;;   :defer-config
;;   (customize-set-variable 'projectile-globally-ignored-modes
;;                           (let ((newlist projectile-globally-ignored-modes))
;;                             (add-to-list 'newlist "vterm-mode"))))


;; (leaf yaml-mode
;;  :ensure t
;;  :leaf-defer t
;;  :mode ("\\.yaml\\" . yaml-mode))

;;  (leaf markdown
;;   :config
;;   (leaf markdown-mode
;;     :ensure t
;;     :leaf-defer t
;;     :mode ("\\.md\\" .gfm-mode)
;;     :custom
;;     (markdown-command . "github-markup")
;;     (markdown-command-needs-filename . t))
;;   (leaf markdown-preview-mode
;;   :ensure t))

;(leaf evil
;  :config (evil-mode 1))

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
