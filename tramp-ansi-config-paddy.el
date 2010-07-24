

(require 'tramp)

;; Add color to a shell running in emacs 'M-x shell'
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(tramp-set-completion-function "ssh"
			       '(
				 (tramp-parse-sknownhosts "~/.ssh/known_hosts")
				 (tramp-parse-sconfig "~/.ssh/config")))

(tramp-parse-sconfig "~/.ssh/config")
(tramp-parse-sknownhosts "~/.ssh/known_hosts")
;(defun term-name-change-respond () 


(provide 'tramp-ansi-config-paddy)