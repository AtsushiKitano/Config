(load-file (expand-file-name "~/.spacemacs.d/configs/user-conf/eshell_conf.el"))
(dolist (path (reverse (split-string (getenv "PATH") ":")))
  (add-to-list 'exec-path path))
