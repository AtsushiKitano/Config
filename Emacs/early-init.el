;;; early-init.el --- Early initialization -*- lexical-binding: t -*-
;;; Commentary:
;; フレーム生成前に実行される設定。
;; ツールバー等の UI 要素をここで無効化することで起動時の一瞬表示を防ぐ。
;;; Code:

;;; native-comp ワーニングを抑制
(setq native-comp-async-report-warnings-errors 'silent)

;;; フレームパラメータ（フレーム生成前に適用）
;;; tool-bar-lines / menu-bar-lines を 0 にすることで起動時のフラッシュを防ぐ
(setq default-frame-alist
      (append '((tool-bar-lines       . 0)
                (menu-bar-lines       . 0)
                (vertical-scroll-bars . nil)
                (left-fringe          . 12)
                (right-fringe         . 12)
                (line-spacing         . 0)
                (cursor-type          . box))
              default-frame-alist))
(setq initial-frame-alist default-frame-alist)

;;; early-init.el ends here
