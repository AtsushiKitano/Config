(use-package typescript-mode
  :config
  (setq typescript-indent-level 2)
  (add-hook 'typescript-mode-hook
            (lambda ()
              (interactive)
              (mmm-mode)
              )))

(use-package mmm-mode
  :commands mmm-mode
  :mode (("\\.tsx\\'" . typescript-mode))
  :config
  (setq mmm-global-mode t)
  (setq mmm-submode-decoration-level 0)
  (mmm-add-classes
   '((mmm-jsx-mode
      :submode web-mode
      :face mmm-code-submode-face
      :front "\\(return\s\\|n\s\\|(\n\s*\\)<"
      :front-offset -1
      :back ">\n?\s*)\n}\n"
      :back-offset 1
      )))
  (mmm-add-mode-ext-class 'typescript-mode nil 'mmm-jsx-mode)


  (defun mmm-reapply ()
    (mmm-mode)
    (mmm-mode))

  (add-hook 'after-save-hook
            (lambda ()
              (when (string-match-p "\\.tsx?" buffer-file-name)
                (mmm-reapply)
                )))
  )
