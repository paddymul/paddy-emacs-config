;(autoload 'erc "erc" "" t)

(load "~/.ssh/.erc_auth.el")
(defun erc-freenode ()
  (interactive)
  (erc-select :server "irc.freenode.net" :port 6667 :nick "paddy_m" :full-name "Paddy Mullen" :password ,paddy-erc-password))