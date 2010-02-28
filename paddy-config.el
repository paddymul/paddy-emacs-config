;;;;;;;;; entry points to all of my specific config files

;;;;; requirements are ordered by importance, likehood to fail, and time it takes to load
;;; if something fails I want to be able to edit my files
;;; I also want as much of my environemnt as possible
;;; last I don't want it to take a long time to fail

;;; global configs

(require 'paddy-global)
(require 'paddy-load-externals)
(require 'paddy-key-config)
(require 'paddy-help-fns)
(require 'paddy-anything-config)
(require 'paddy-py-config)

;(/ 1 0)

;;;;specific mode configs
(require 'paddy-shell-config) ;; most important
;(require 'paddy-w3m-config)    -- doesn't work in 23


(require 'paddy-sql-config)

(require 'paddy-tramp-ansi-config)
(require 'paddy-slime-config)  ;;;;; very likely to fial



;;;;;;;;
(require 'paddy-desktop-config) ;;;;; down here because it takes the longest to load
(require 'paddy-font-config) ;; likely to fail, slow
;(require 'paddy-html-config)
(provide 'paddy-config)


(defun my-compile ()
  (interactive)
  (compile  "python /Users/patrickmullen/permalink/tests/play.py" t))