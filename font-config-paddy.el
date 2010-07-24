

(defun paddy-set-very-small-font ()
  (interactive)
  (set-default-font
   "-apple-monaco-medium-r-normal--10-140-72-72-m-140-mac-roman"))
(defun paddy-set-small-font ()
  (interactive)
  (set-default-font
   "-apple-monaco-medium-r-normal--12-140-72-72-m-140-mac-roman"))
(defun paddy-set-medium-font ()
  (interactive)
  (set-default-font
   "-apple-monaco-medium-r-normal--14-140-72-72-m-140-mac-roman"))
  (defun paddy-set-smallest-font ()
    (interactive)
    (set-default-font "-apple-bitstream vera sans mono-medium-r-normal--0-0-0-0-m-0-iso10646-1"))
(defun paddy-set-ubuntu-font ()
  (interactive)
  (set-default-font "-unknown-Inconsolata-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1"))
;(set-default-font "Monospace-8")
(set-default-font "Monospace-10")

(provide 'font-config-paddy)
