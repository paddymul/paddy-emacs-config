(cond
 ((string-match "GNU" (emacs-version))
  (cond 
   ((string-match "linux" system-configuration)
    (if (file-exists-p "~/.emacs-gnu-linux")
	(progn
	  (message "loading GNU Emacs customizations for Linux")
	  (load-file "~/.emacs-gnu-linux"))))
   ((string-match "Carbon" (emacs-version))
    (progn

      t))
   ) ; matched GNU
  ))

      (if (fboundp 'tool-bar-mode)
	  (tool-bar-mode -1))


;(setq custom-file "~/me/emacs/.emacs-custom.el")
(setq custom-file "~/.emacs.d/.emacs-custom.el")
(load custom-file)



(when
    (load
     (expand-file-name "~/.emacs.d/vendor/package-el/package.el"))
  (package-initialize))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/vendor/php-mode"))
(require 'paddy-config)
(put 'set-goal-column 'disabled nil)


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
