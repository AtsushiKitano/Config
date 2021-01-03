(add-hook 'css-mode-hook 'flycheck-mode)
(add-hook 'css-mode-hook
          (lambda()
            (setq tab-width 2)
            ))
