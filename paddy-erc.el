(autoload 'erc "erc" "" t)

(defmacro asf-erc-bouncer-connect (command server port nick ssl pass)
  "Create interactive command `command', for connecting to an IRC server. The
   command uses interactive mode if passed an argument."
  (fset command
        `(lambda (arg)
           (interactive "p")
	   (if (not (= 1 arg))
	       (call-interactively 'erc)
	     (let ((erc-connect-function ',(if ssl
					       'erc-open-ssl-stream
					     'open-network-stream)))
 	       (erc :server ,server :port ,port :nick ,nick :password ,pass))))))

(setq erc-echo-notices-in-minibuffer-flag t)
(asf-erc-bouncer-connect erc-opn "irc.freenode.net" 6666  "paddymullen" nil "greenbox")

(setq erc-current-nick-highlight-type 'nick)
(setq erc-keywords '("\\berc[-a-z]*\\b" "\\bemms[-a-z]*\\b"))

(setq erc-track-exclude-types '("JOIN" "PART" "QUIT" "NICK" "MODE"))
(setq erc-track-use-faces t)
(setq erc-track-faces-priority-list
      '(erc-current-nick-face erc-keyword-face))
(setq erc-track-priority-faces-only 'all)
