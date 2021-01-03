(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'python-mode-hook
          (lambda()
            (setq python-indent 2)
            (setq indent-tabs-mode nil)
            ))
