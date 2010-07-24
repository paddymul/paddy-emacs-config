;(add-to-list 'load-path "~/.emacs.d/vendor/slime/")  ; your SLIME directory

;(require 'slime)
                                        ;(slime-setup)

(when nil
;(setq inferior-lisp-program "/usr/local/bin/sbcl") ;; mac specific
(setq inferior-lisp-program "/usr/bin/sbcl")  ;; linux specific



(setq slime-lisp-implementations
   '(
     
     (sbcl ("/usr/local/bin/sbcl" "--core" "/Users/pinochle/bin/sbcl.core-with-swank") 
           :init (lambda (port-file _) 
                   (format "(swank:start-server %S :coding-system \"utf-8-unix\")\n" port-file)))
     (clojure ("/Users/pinochle/bin/clojure") :init swank-clojure-init))))

;(add-to-list 'load-path "~/.emacs.d/vendor/clojure-mode")
(require 'clojure-mode)


;(add-to-list 'load-path 
;             (expand-file-name "~/.emacs.d/vendor/swank-clojure"))
(setq swank-clojure-jar-home "/opt/jars")
(setq swank-clojure-deps (list 
                          "/opt/jars/swank-clojure.jar"
                          "/opt/jars/clojure.jar"
                          "/opt/jars/clojure-contrib.jar"))
(require 'swank-clojure)


;(add-to-list 'load-path (expand-file-name "~/.emacs.d/slime"))
(require 'slime)
(slime-setup '(slime-fancy))
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))


;; clojure-mode

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


(provide 'slime-config-paddy)