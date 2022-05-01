(use-package dap-mode
  :after lsp-mode
  :custom
  (dap-auto-configure-features '(sessions locals breakpoints expressions repl controls tooltip))
  :config
  (dap-mode 1)
  (dap-auto-configure-mode 1)
  (require 'dap-hydra) ; hydraでDAPの操作を楽にするもの(Optional)
  (require 'dap-go))
