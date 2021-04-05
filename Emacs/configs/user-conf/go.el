(use-package go-mode
  :mode "\\.go\\'"
  :interpreter "go"
  :init
  (add-hook 'go-mode-hook (lambda()
                            ('flycheck-mode)
                            (add-hook 'before-save-hook' 'gofmt-before-save)
                            (local-set-key (kbd "M-.") 'godef-jump)
                            (setq indent-tabs-mode nil)
                            (setq c-basic-offset 4)
                            (setq tab-width 4)
                            )
  )
