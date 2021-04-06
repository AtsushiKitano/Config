(use-package add-node-modules-path
  :hook (js-mode js2-mode))

(setq js2-include-browser-externs nil)
(setq js2-mode-show-parse-errors nil)
(setq js2-mode-show-strict-warnings nil)
(setq js2-highlight-external-variables nil)
(setq js2-include-jslint-globals nil)

;; (add-hook 'js-mode-hook
;;           (lambda()
;;             (make-local-variable 'js-indent-level)
;;             (setq tab-width 2)
;;             (setq js-indent-level 2)))
