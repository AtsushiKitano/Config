(setq alpha-on-flag nil)
(defun alpha-toggle()
  (interactive)
  (if (equal alpha-on-flag t)
      (progn
        (set-frame-parameter nil 'alpha 100)
        (setq alpha-on-flag nil)
        (message "alpha-off"))
    (progn
      (set-frame-parameter nil 'alpha 80)
      (setq alpha-on-flag t)
      (message "alpha-on"))))
(define-key global-map (kbd "C-c C-a") 'alpha-toggle)
