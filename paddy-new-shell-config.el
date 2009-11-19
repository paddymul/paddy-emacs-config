
;; Add color to a shell running in emacs 'M-x shell'
(require 'term)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


(defun prompt-for-shell-name (shell-name)
  (interactive "s what do you want to name your new shell? ")
  (switch-to-buffer "*shell*")
  (rename-buffer "temp-shell-*******")
  (shell)
  (rename-buffer shell-name)
  (switch-to-buffer "temp-shell-*******")
  (rename-buffer "*shell*")
  (switch-to-buffer shell-name))



(defun new-shell ()
  (interactive)
  (if (string-equal (buffer-name) "*shell*")
        (command-execute 'prompt-for-shell-name)
      (shell)))

(add-hook  'shell-mode-hook 
	  '(lambda ()
             (define-key shell-mode-map   (kbd "C-M-a")  'comint-previous-prompt)
             (define-key shell-mode-map   (kbd "C-M-e")  'comint-next-prompt)))





;; Nice shell features. 
(add-hook 'shell-mode-hook 'n-shell-mode-hook)
(defun n-shell-mode-hook ()
  "Shell mode customizations."
  (local-set-key '[up] 'n-shell-up1line)
  (local-set-key '[down] 'n-shell-down1ine)
					;  (local-set-key '[(shift tab)] 'comint-next-matching-input-from-input)
					; (setq comint-input-sender 'n-shell-simple-send)
  )

(defun n-shell-up1line()
  "Insert previous input if we are at the command line"
  (interactive)
  (if (not (comint-after-pmark-p)) ( forward-line  -1)
    (comint-previous-input 1) ))

(defun n-shell-down1ine()
  "Insert next input if we are at the command line"
  (interactive)
  (if (not (comint-after-pmark-p)) (forward-line  1)
    (comint-next-input 1) ))


(provide 'paddy-shell-config)