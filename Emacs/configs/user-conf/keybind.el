;; Key Binding
(require 'bind-key)

;; window control
(bind-key "M-[" 'previous-multiframe-window)
(bind-key "M-]" 'next-multiframe-window)
(bind-key "C-t" 'next-multiframe-window)
(bind-key "C-x o" 'ace-window)
(bind-key "M-2" 'split-window-vertically)
(bind-key "M-3" 'split-window-horizontally)
(bind-key "C-z" 'delete-window)
(bind-key "M-z" 'delete-other-windows)
(bind-key "C-x b" 'switch-to-buffer)

;; backspace をC-hに割り当てる設定
(bind-key (kbd "C-h") 'delete-backward-char)
(define-key global-map (kbd "C-h") 'delete-backward-char)

;; 単語のごとのカーソル移動
(bind-key "M-f" 'forward-word)
(bind-key "M-b" 'backward-word)

;; 動的展開機能のkeybind
(define-key global-map (kbd "C-:") 'dabbrev-expand)

;; 円マークをバックスラッシュに変換
(define-key global-map [?¥] [?\\])

;; shell
(bind-key (kbd "C-c s") 'eshell)

(global-set-key "\M-p" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
