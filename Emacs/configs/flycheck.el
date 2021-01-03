(use-package flycheck
  :config
  (global-flycheck-mode t)
  :custom
  (flycheck-disabled-checkers '(javascript-jshint javascript-jscs))
  )
