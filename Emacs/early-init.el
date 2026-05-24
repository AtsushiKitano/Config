;;; early-init.el -*- coding: utf-8 ; lexical-binding: t -*-

(setq debug-on-error t)

(let ((x-init-org (concat user-emacs-directory "init.org"))
		(x-init-el (concat user-emacs-directory "init.el")))
(when (file-newer-than-file-p x-init-org x-init-el)
	(message "WARN: init.el is old.\n")))

;; ツールバー非表示
(tool-bar-mode 0)

;; スクロールバーの非表示
(set-scroll-bar-mode nil)

;;  行番号の表示
(global-display-line-numbers-mode t)
(custom-set-variables '(display-line-numbers-width-start t))

;; タブの表示
(tab-bar-mode t)

;; native-comp ワーニングの抑制
(custom-set-variables '(warning-suppress-types '((comp))))

(setq default-frame-alist
		(append '((width . 140) ;フレーム幅
				  (height . 40) ; フレーム高
				  (left . 170) ; 配置左
				  (top . 30) ; 配置上
				  (line-spacing . 0) ; 文字間隔
				  (left-fringe . 12) ; 左フリンジ幅
				  (right-fringe . 12) ; 右フリンジ幅
				  (menu-bar-lines . 1) ; メニューバー
				  (cursor-type . box) ; カーソル種別
				  (alpha . 90) ; 透明度
			  )
			default-frame-alist))
(setq initial-frame-alist default-frame-alist)

;;; early-init.el ends here
