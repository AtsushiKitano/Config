(use-package json-mode
  :mode "\\.json\\'"
  :config
  (add-hook 'json-mode-hook
            (lambda()
              (make-local-variable 'js-indent-level)
              (setq js-indent-level 2)
              ))
  )
