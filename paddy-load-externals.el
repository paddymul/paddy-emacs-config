(add-to-list 'load-path (expand-file-name "~/me/emacs/semantic-1.4.4/"))
(add-to-list 'load-path "/Users/patrickmullen/me/emacs/mmm-mode-0.4.8/")
(add-to-list 'load-path (expand-file-name "~/me/emacs/speedbar-0.14beta4/"))
(add-to-list 'load-path (expand-file-name "~/me/emacs/cedet-1.0pre4/common/"))
(load-file (expand-file-name "~/me/emacs/cedet-1.0pre4/common/cedet.el"))

(load-file (expand-file-name "~/me/emacs/csv-mode.el"))
(require 'git)

(provide 'paddy-load-externals)