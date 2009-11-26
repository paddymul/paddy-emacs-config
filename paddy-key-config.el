
(cond
 ((string-match "GNU" (emacs-version))
  (cond 
   ((string-match "linux" system-configuration)
    (if (file-exists-p "~/.emacs-gnu-linux")
	(progn
	  (message "loading GNU Emacs customizations for Linux")
	  (load-file "~/.emacs-gnu-linux"))))
   ((string-match "darwin" (emacs-version))
    (progn
      (message "mac")
      (setq mac-option-modifier 'hyper)
      (setq mac-command-modifier 'meta)
      t
      ))
   )					; matched GNU
  ))

(progn 
  (setq my-key-pairs
        '(
          ;(?! ?1) (?@ ?2) (?# ?3) (?$ ?4) (?% ?5)
          ;(?^ ?6) (?& ?7) (?* ?8) (?( ?9) (?) ?0)
          ;(?- ?_) (?\" ?')  (?{ ?[) (?} ?]) ; (?| ?\\)

          ;(?[ ?{)  (?] ?})
          (?( ?[)  (?) ?])  
          ;(?( ?{)  (?) ?}) 
          ;(?{ ?[)  (?} ?]) 
          ))
        
  (defun my-key-swap (key-pairs)
    (if (eq key-pairs nil)
        (message "Keyboard zapped!! Shift-F10 to restore!")
      (progn
        (keyboard-translate (caar key-pairs)  (cadar key-pairs)) 
        (keyboard-translate (cadar key-pairs) (caar key-pairs))
        (my-key-swap (cdr key-pairs))
        )
      ))

  (defun my-key-restore (key-pairs)
    (interactive)
    (if (eq key-pairs nil)
        (message "Keyboard restored!! F10 to Zap!")
      (progn
        (keyboard-translate (caar key-pairs)  (caar key-pairs))
        (keyboard-translate (cadar key-pairs) (cadar key-pairs))
        (my-key-restore (cdr key-pairs))
        )
      ))
  (my-key-swap my-key-pairs))




;Eventually these should be JDEE mode only
;(global-unset-key "\M-?") ;; I don't know what this is bound to now 
;(global-set-key "\M-'" 'jde-complete-in-line)
;(global-set-key "\M-\"" 'jde-complete-menu)






;notsure



;;;;;window movement keys
(defun _paddy-enlarge-window-horizontal ()
  (interactive)
  (enlarge-window 1 1))

(defun _paddy-shrink-window-horizontal ()
  (interactive)
  (shrink-window 1 1))

(global-unset-key (kbd "M-`") )
(global-set-key (kbd "H-P") 'enlarge-window)
(global-set-key (kbd "H-p") 'windmove-up)
(global-set-key (kbd "H-N") 'shrink-window)
(global-set-key (kbd "H-n") 'windmove-down)
(global-set-key (kbd "H-F") '_paddy-enlarge-window-horizontal)
(global-set-key (kbd "H-f") 'windmove-right)
(global-set-key (kbd "H-B") '_paddy-shrink-window-horizontal)
(global-set-key (kbd "H-b") 'windmove-left)
(global-set-key (kbd "H-w") 'delete-window)
(global-set-key (kbd "H-o") 'other-window)


;;;;;;;;;buffer movement commands ---anything

(global-set-key  '[C-tab] 'bs-cycle-next)
(global-set-key '[C-S-tab] 'bs-cycle-previous)

(global-set-key (kbd "H-g") 'find-grep)
(global-set-key (kbd "H-w") 'delete-window)
(global-set-key (kbd "H-o") 'other-window)
(global-set-key (kbd "H-q") 'shell)
(global-set-key (kbd "H-s") 'new-shell)



(global-set-key "\C-x\C-F" 'find-file)
(global-unset-key (kbd "C-S-F"))
(global-set-key (kbd "C-x C-S-f") 'find-file-other-window)

;--anything
(global-set-key (kbd "H-a") 'anything)

(global-set-key (kbd "H-\\") 'anything)
(global-set-key (kbd "H-x") 'paddy-M-x-anything)
(global-set-key (kbd "M-x") 'execute-extended-command)
(global-set-key (kbd "M-y") 'anything-show-kill-ring)


(global-set-key (kbd "C-h g") 'help-paddy-goto-function)
(define-key isearch-mode-map (kbd "C-y") 'isearch-yank-kill)

;;;;;;;;;;editting commands
(global-set-key (kbd "C-=") 'unexpand-abbrev)


(global-set-key (kbd "H-r") '(lambda () 
                               (interactive)
                               (revert-buffer)))
(global-set-key "\M-S-g" 'goto-line)
(global-set-key (kbd "S-M-g") 'goto-line)


; Yegge advice
(global-unset-key  "\C-w" )
(global-set-key  (kbd "C-w") 'backward-kill-word)

(global-unset-key (kbd "C-S-w") )
(global-set-key (kbd "C-S-w") 'kill-word)


(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)




;; Nice shell features. 
(add-hook 'shell-mode-hook 'n-shell-mode-hook)
(defun n-shell-mode-hook ()
  "Shell mode customizations."
  (local-set-key '[up] 'n-shell-up1line)
  (local-set-key '[down] 'n-shell-down1ine)
  ;(local-set-key '[(shift tab)] 'comint-next-matching-input-from-input)
  ;(setq comint-input-sender 'n-shell-simple-send)
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

(provide 'paddy-key-config)