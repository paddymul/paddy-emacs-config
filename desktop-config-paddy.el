

;; Customization goes between desktop-load-default and desktop-read
(setq history-length 2500)
(setq desktop-save t)
(setq desktop-load-locked-desktop t)
;(add-to-list 'desktop-globals-to-save 'file-name-history)

(setq *foo-desktop-dir* (expand-file-name "~/.emacs.d/desktop"))

(setq desktop-dir *foo-desktop-dir*)
(setq desktop-path (list *foo-desktop-dir*))
(desktop-save-mode 1) ;; Switch on desktop.el
(setq desktop-lazy-idle-delay 0)
(setq *foo-desktop-file* (concatenate 'string desktop-dir
                                      "/" 
                                      desktop-base-file-name))
;(desktop-load-default)



;; (defun desktop-in-use-p ()
;;   (and (file-exists-p *foo-desktop-file*)
;;        (file-exists-p *foo-desktop-lock*)))
;; (defun autosave-desktop ()
;;   (if (desktop-in-use-p)
;;       (desktop-save-in-desktop-dir)))

;; Can be switched off with (cancel-timer *foo-desktop-saver-timer*)
;; (add-hook 'after-init-hook
;;           (lambda ()
;;             (setq *foo-desktop-saver-timer* 
;;                   (run-with-timer 5 300 'autosave-desktop))))
;; 

(setq *foo-desktop-dir* (expand-file-name "~/.emacs.d/desktop"))
(setq desktop-dir *foo-desktop-dir*)
(setq desktop-path (list *foo-desktop-dir*))
(desktop-save-mode 1) ;; Switch on desktop.el
(setq *foo-desktop-file* (concatenate 'string desktop-dir
                                      "/" desktop-base-file-name))
(setq *foo-desktop-lock* (concatenate 'string desktop-dir
                                      "/" desktop-base-lock-name))
(defun desktop-in-use-p ()
  (and (file-exists-p *foo-desktop-file*) (file-exists-p *foo-desktop-lock*)))
(defun autosave-desktop ()
  (if (desktop-in-use-p) (desktop-save-in-desktop-dir)))
;; Can be switched off with (cancel-timer *foo-desktop-saver-timer*)
(add-hook 'after-init-hook
          (lambda ()
            (setq *foo-desktop-saver-timer*
                  (run-with-timer 5 300 'autosave-desktop))))


;; changed so that i no longer messages that the desktop was saved
(defun desktop-save-in-desktop-dir ()
  "Save the desktop in directory `desktop-dirname'."
  (interactive)
  (if desktop-dirname
      (desktop-save desktop-dirname)
    (call-interactively 'desktop-save))
;;  (message "Desktop saved in %s" (abbreviate-file-name desktop-dirname))

)

(provide 'desktop-config-paddy)
