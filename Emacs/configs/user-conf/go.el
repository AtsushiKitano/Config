(setenv "GOROOT" "/Users/kitano.atsushi/.goenv/versions/1.17.7")
(setenv "GOPATH" "/Users/kitano.atsushi/go/1.17.7")

(use-package go-mode
  :mode "\\.go\\'"
  :interpreter "go"
  :init
  (add-hook 'go-mode-hook (lambda()
                            ('flycheck-mode)
                            (add-hook 'before-save-hook' 'gofmt-before-save)
                            (local-set-key (kbd "M-.") 'godef-jump)
                            (setq indent-tabs-mode nil)
                            (setq c-basic-offset 4)
                            (setq tab-width 4))))

;;; Setup

(require 'company)                                   ; load company mode
(require 'company-go)                                ; load company mode go backend

;;; Possible improvements

(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)                          ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing

;;; Only use company-mode with company-go in go-mode

(add-hook 'go-mode-hook (lambda ()
                          (set (make-local-variable 'company-backends) '(company-go))
                          (company-mode)))

;;; Color customization

(custom-set-faces
 '(company-preview
   ((t (:foreground "darkgray" :underline t))))
 '(company-preview-common
   ((t (:inherit company-preview))))
 '(company-tooltip
   ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-selection
   ((t (:background "steelblue" :foreground "white"))))
 '(company-tooltip-common
   ((((type x)) (:inherit company-tooltip :weight bold))
    (t (:inherit company-tooltip))))
 '(company-tooltip-common-selection
   ((((type x)) (:inherit company-tooltip-selection :weight bold))
    (t (:inherit company-tooltip-selection)))))
