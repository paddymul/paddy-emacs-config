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
      (if (fboundp 'tool-bar-mode)
	  (tool-bar-mode -1))
      t))
   ) ; matched GNU
  ))




;(setq custom-file "~/me/emacs/.emacs-custom.el")
(setq custom-file "~/.emacs.d/.emacs-custom.el")
(load custom-file)


(add-to-list 'load-path (expand-file-name "~/.emacs.d/"))
(require 'paddy-config)
(put 'set-goal-column 'disabled nil)
