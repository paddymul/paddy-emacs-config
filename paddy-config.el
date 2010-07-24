;;;;;;;;; entry points to all of my specific config files

;;;;; requirements are ordered by importance, likehood to fail, and time it takes to load
;;; if something fails I want to be able to edit my files
;;; I also want as much of my environemnt as possible
;;; last I don't want it to take a long time to fail

;;; global configs

(require 'global-paddy-config)
(require 'load-externals-paddy)
(require 'key-config-paddy)
(require 'help-fns-paddy)
(require 'anything-config-paddy)
(require 'py-config-paddy)

;(/ 1 0)
(require 'diff-config)
(require 'org-paddy)
(require 'vc-config)
;;;;specific mode configs
(require 'shell-config-paddy) ;; most important
;(require 'paddy-w3m-config)    -- doesn't work in 23


(require 'sql-config-paddy)

(require 'tramp-ansi-config-paddy)
(require 'slime-config-paddy)  ;;;;; very likely to fial



;;;;;;;;
(require 'desktop-config-paddy) ;;;;; down here because it takes the longest to load
(require 'font-config-paddy) ;; likely to fail, slow
;(require 'paddy-html-config)
(provide 'paddy-config)


(defun my-compile ()
  (interactive)
  (compile  "python /Users/patrickmullen/permalink/tests/play.py" t))