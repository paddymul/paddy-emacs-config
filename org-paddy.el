(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(require 'org)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(global-set-key "\C-cb" 'org-iswitchb)


(define-key org-mode-map (kbd "C-c C-o") 'hide-subtree)
(add-hook 'org-mode-hook
	  '(lambda ()
             (auto-fill-mode)))

(provide 'org-paddy)

