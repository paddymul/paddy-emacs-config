
 (load "~/me/emacs/nxml-mode-20041004/rng-auto.el")
 (setq auto-mode-alist
       (cons '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode)
             auto-mode-alist))
  (setq magic-mode-alist
	  (cons '("<\\?xml " . nxml-mode)
	  magic-mode-alist))
   (fset 'xml-mode 'nxml-mode)
   (fset 'html-mode 'nxml-mode)

(provide 'paddy-html-config)