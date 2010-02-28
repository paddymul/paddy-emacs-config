(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)

(add-hook 'javascript-mode-hook 'javascript-custom-setup)
(defun javascript-custom-setup ()
  (moz-minor-mode 1))


(add-to-list 'load-path "~/me/emacs/js2/")

(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(defun js2-paddy-hook ()
  (local-set-key "s-'" 'js2-next-error))
(add-hook 'js2-mode-hook 'js2-paddy-hook)
(add-to-list 'auto-mode-alist '("\\.js$" . java-mode))
(load-file (expand-file-name "~/me/emacs/mozrepl/javascript.el"))
(load-file (expand-file-name "~/me/emacs/mozrepl/moz.el"))
(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)
(add-hook 'java-mode-hook 'java-custom-setup)
(defun java-custom-setup ()
  (moz-minor-mode 1))

(add-to-list 'auto-mode-alist '("\\.jar\\'" . archive-mode))
(provide 'paddy-js-config)
