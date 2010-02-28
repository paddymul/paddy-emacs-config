
(defun paddy-do-paren-key-switching () 
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
      (setq mac-option-modifier 'super)
      (setq mac-command-modifier 'meta)
      (paddy-do-paren-key-switching)
      t
      ))
   )					; matched GNU
  ))




;Eventually these should be JDEE mode only
;(global-unset-key "\M-?") ;; I don't know what this is bound to now 
;(global-set-key "\M-'" 'jde-complete-in-line)
;(global-set-key "\M-\"" 'jde-complete-menu)



(global-unset-key (kbd "C-\\")) ;; I never toggle input method
(global-unset-key (kbd "M-o"))  ;; I never want to set-face-font but I often accidently type this when I want s-o


;notsure



;;;;;window movement keys
(defun _paddy-enlarge-window-horizontal ()
  (interactive)
  (enlarge-window 1 1))

(defun _paddy-shrink-window-horizontal ()
  (interactive)
  (shrink-window 1 1))

(global-unset-key (kbd "M-`") )
(global-set-key (kbd "s-P") 'enlarge-window)
(global-set-key (kbd "s-p") 'windmove-up)
(global-set-key (kbd "s-N") 'shrink-window)
(global-set-key (kbd "s-n") 'windmove-down)
(global-set-key (kbd "s-F") '_paddy-enlarge-window-horizontal)
(global-set-key (kbd "s-f") 'windmove-right)
(global-set-key (kbd "s-B") '_paddy-shrink-window-horizontal)
(global-set-key (kbd "s-b") 'windmove-left)
(global-set-key (kbd "s-w") 'delete-window)
(global-set-key (kbd "s-o") 'other-window)


;;;;;;;;;buffer movement commands ---anything

;(global-set-key  '[C-tab] 'bs-cycle-next)
;(global-set-key '[C-S-tab] 'bs-cycle-previous)
(global-unset-key '[C-tab])
(global-unset-key '[C-S-tab])


(global-set-key (kbd "s-g") 'find-grep)
(global-set-key (kbd "s-w") 'delete-window)
(global-set-key (kbd "s-o") 'other-window)
(global-set-key '[s-return] 'other-window)
(global-set-key '[s-tab] 'other-window)
(global-set-key (kbd "s-s") 'split-window-horizontally)
(global-set-key (kbd "s-S") 'split-window-vertically)

(global-set-key (kbd "s-'") 'new-shell)



(global-set-key "\C-x\C-F" 'find-file)
(global-unset-key (kbd "C-S-F"))
(global-set-key (kbd "C-x C-S-f") 'find-file-other-window)

;--anything
(global-set-key (kbd "s-a") 'anything)

(global-set-key (kbd "s-\\") 'anything)
(global-set-key (kbd "s-x") 'paddy-M-x-anything)
(global-set-key (kbd "M-x") 'execute-extended-command)
(global-set-key (kbd "M-y") 'anything-show-kill-ring)


(global-set-key (kbd "C-h g") 'help-paddy-goto-function)
(define-key isearch-mode-map (kbd "C-y") 'isearch-yank-kill)

;;;;;;;;;;editting commands
(global-set-key (kbd "C-=") 'unexpand-abbrev)


(global-set-key (kbd "s-r") '(lambda () 
                               (interactive)
                               (revert-buffer)))
(global-set-key (kbd "M-S-g") 'goto-line)
(global-set-key (kbd "S-M-g") 'goto-line)


; Yegge advice
(global-unset-key (kbd "C-w") )
(global-set-key  (kbd "C-w") 'backward-kill-word)

(global-unset-key (kbd "C-S-w") )
(global-set-key (kbd "C-S-w") 'kill-word)

(defun paddy-kill-from-begining-of-line ()
  (interactive)
  (move-beginning-of-line 1)           
  (kill-line))

(global-set-key (kbd "C-S-k") 'paddy-kill-from-begining-of-line)
(global-set-key (kbd "C-k") 'kill-line)

;(global-set-key "\C-x\C-k" 'kill-region)
;(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key (kbd "C-x C-k") 'kill-region)

(global-set-key (kbd "C-j") 'kill-region)
(global-set-key (kbd "C-c C-k") 'kill-region)




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