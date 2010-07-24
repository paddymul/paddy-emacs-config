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


;; clojure-mode
(add-to-list 'load-path "~/code/lisp/clojure-mode")
(require 'clojure-mode)

;; swank-clojure
;(add-to-list 'load-path "~/opt/swank-clojure/src/emacs")

;(setq swank-clojure-jar-path "~/.clojure/clojure.jar"
;      swank-clojure-extra-classpaths (list
;				      "~/opt/swank-clojure/src/main/clojure"
;				      "~/.clojure/clojure-contrib.jar"))

;(require 'swank-clojure-autoload)

;; slime
;(eval-after-load "slime" 
;  '(progn (slime-setup '(slime-repl))))

;(add-to-list 'load-path "~/opt/slime")
;(require 'slime)
;(slime-setup) 


(provide 'paddy-slime-config)