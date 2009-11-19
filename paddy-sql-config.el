(add-hook 'sql-mode-hook
	  (lambda ()
            (local-set-key (kbd "M-p") 'backward-paragraph)
            (local-set-key (kbd "M-n") 'forward-paragraph)
            (require 'sql-indent)
	    (abbrev-mode)))

(setq  sql-mode-hook nil)
(add-hook 'sql-interactive-mode-hook
	  (lambda ()
	    (abbrev-mode)))

(load-file (expand-file-name "~/me/emacs/sql-indent.el"))
(require 'sql-indent)

(unwind-protect
    (load-file (expand-file-name "~/.ssh/sql-ec2-logins.el")))
  

(provide 'paddy-sql-config)