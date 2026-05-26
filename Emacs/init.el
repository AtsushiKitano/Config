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
	(with-selected-frame (or frame (selected-frame))
	  (when (display-graphic-p)
		(let* ((family "Fira Code")
			   (fontspec (font-spec :family family :weight 'normal)))
		  (set-face-attribute 'default nil :family family :height 180)
		  (set-fontset-font nil 'ascii fontspec nil 'append)
		  (set-fontset-font nil 'japanese-jisx0208 fontspec nil 'append)))))
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
  (doom-modeline-hub . t))

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
  (migemo-dictionary . "/usr/share/cmigemo/utf-8/migemo-dict")
  (migemo-user-dictionary . nil)
  (migemo-regex-dictionary . nil)
  (migemo-coding-system . 'utf-8-unix)
  :config
  (migemo-init))

(leaf evil
  :ensure t
  :custom
  (evil-want-integration . t)
  (evil-want-keybinding . nil)
  (evil-want-C-u-scroll . t)
  :config
  (evil-mode 1)
  (dolist (mode '(vterm-mode dired-mode magit-mode imenu-list-major-mode eat-mode))
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
    "リージョンが選択されていればコピー（kill-ring-save）する。"
    (interactive)
    (if (use-region-p)
        (progn
          (kill-ring-save (region-beginning) (region-end))
          (deactivate-mark)
          (message "Copied region"))
      (message "No region selected")))
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

(leaf isearch
  :doc "isearch 中の次／前候補ナビゲーション"
  :bind
  (:isearch-mode-map
   ;; C-n: 次のヒットへ / C-b: 前のヒットへ
   ("C-n" . isearch-repeat-forward)
   ("C-b" . isearch-repeat-backward)))

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
                                           (eat-self-input 1 ?\177))))

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
   ("C-x j"   . skk-mode))
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

(leaf-keys (("C-h" . backward-delete-char)
            ("M-h" . previous-multiframe-window)
            ("M-l" . next-multiframe-window)
            ("M-z" . delete-other-windows)))

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
      (add-hook hook #'my/eglot-ts-workspace-config))))

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
  )

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

(leaf markdown-mode
  :ensure t
  :mode
  (("\\.md\\'" . gfm-mode))
  )
