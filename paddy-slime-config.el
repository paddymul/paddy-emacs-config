(add-to-list 'load-path "~/.emacs.d/vendor/slime/")  ; your SLIME directory

;(require 'slime)
                                        ;(slime-setup)


;(setq inferior-lisp-program "/usr/local/bin/sbcl") ;; mac specific
(setq inferior-lisp-program "/usr/bin/sbcl")  ;; linux specific

;(add-to-list 'load-path (expand-file-name "~/.emacs.d/slime"))
(require 'slime)
;(slime-setup)
(slime-setup '(slime-fancy))
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
(provide 'paddy-slime-config)