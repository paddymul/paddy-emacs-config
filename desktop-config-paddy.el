(require 'desktop)
(setq desktop-save t)
(setq history-length 250)
(add-to-list 'desktop-globals-to-save 'file-name-history)
(setq desktop-dirname (expand-file-name "~/.emacs.d/desktop"))



(defun paddy-load-desktop-later () 
  (message "paddy-load-desktop-later")
  (desktop-read desktop-dirname))
; (run-with-timer 5 nil 'paddy-load-desktop-later)
  (desktop-read desktop-dirname)
(defun paddy-desktop-save-in-desktop-dir ()
  "Save the desktop in directory `desktop-dirname'.
    Like desktop-save-in-desktop-dir, but without the messaging"
  (interactive)
  (if desktop-dirname
      (desktop-save desktop-dirname)
    (call-interactively 'desktop-save)))
(add-hook 'auto-save-hook 'paddy-desktop-save-in-desktop-dir)
;; ;; Customization goes between desktop-load-default and desktop-read
;; (setq history-length 2500)

;; (setq desktop-load-locked-desktop t)
;; ;(add-to-list 'desktop-globals-to-save 'file-name-history)

;; (setq desktop-lazy-idle-delay 0)
;; (setq desktop-dir (expand-file-name "~/.emacs.d/desktop"))

;; (setq desktop-dirname desktop-dir)

;; (defun desktop-save-in-desktop-dir ()
;;   "Save the desktop in directory `desktop-dirname'."
;;   (interactive)
;;   (if desktop-dirname
;;       (desktop-save desktop-dirname)
;;     (call-interactively 'desktop-save)))

;; (desktop-save-mode 1) ;; Switch on desktop.el

;; (defun autosave-desktop ()
;;   (desktop-save-in-desktop-dir))
;; ;; Can be switched off with (cancel-timer *foo-desktop-saver-timer*)
;;


;; ;; changed so that i no longer messages that the desktop was saved

;; ;;  (message "Desktop saved in %s" (abbreviate-file-name desktop-dirname))

;; )

(provide 'desktop-config-paddy)
