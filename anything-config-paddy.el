


(load-file "~/.emacs.d/anything.el")
(require 'anything)
(load-file "~/.emacs.d/anything-config-all.el")
(require 'anything-config)




(setq anything-sources 
      `(((name . "Buffers")
         (candidates
          . (lambda ()
              (remove-if (lambda (name)
                           (or (equal name anything-buffer)
                               (eq ?\  (aref name 0))))
                         (mapcar 'buffer-name (buffer-list)))))
         (type . buffer))
        ((name . "File Name History")
         (candidates . file-name-history)
         (match (lambda (candidate)
                  ;; list basename matches first
                  (string-match 
                   anything-pattern 
                   (file-name-nondirectory candidate)))

                (lambda (candidate)                                     
                  ;; and then directory part matches
                  (let ((dir (file-name-directory candidate)))
                    (if dir
                        (string-match anything-pattern dir)))))
         (type . file))
        ((name . "Files from Current Directory")
         (init . (lambda ()
                   (setq anything-default-directory
                         default-directory)))
         (candidates 
          . (lambda ()
              (if (and
                   (not (equal (substring anything-default-directory 0 5) "/ssh:"))
                   (not (equal (substring anything-default-directory 0 6) "/root@")))
                  (directory-files anything-default-directory))))


         (type . file))))
(setq anything-type-attributes
  '((file 
     (action . (("Find File" . find-file)
                ("Insert File Name" . file-name)
                ("Delete File" . (lambda (file)
                                   (if (y-or-n-p (format "Really delete file %s? "
                                                         file))
                                            (delete-file file)))))))
    (buffer (action . (("Switch to Buffer" . switch-to-buffer)
                       ("Insert Buffer File Name" .  anything-insert-buffer-name )
                       ("Pop to Buffer"    . pop-to-buffer)
                       ("Display Buffer"   . display-buffer)
                       ("Kill Buffer"      . kill-buffer))))))


(define-anything-type-attribute 'command
  `((action ("Call interactively" . anything-c-call-interactively)
            ("Describe command" . anything-c-describe-function)
            ("Add command to kill ring" . anything-c-kill-new)
            ("Go to command's definition" . anything-c-find-function))
    ;; Sort commands according to their usage count.
    (filtered-candidate-transformer . anything-c-adaptive-sort))
  "Command. (string or symbol)")


(progn
(define-anything-type-attribute 'command
  `((action ("Call interactively" . anything-c-call-interactively)
            ("Describe command" . anything-c-describe-function)
            ("Add command to kill ring" . anything-c-kill-new)
            ("Go to command's definition" . anything-c-find-function))
    ;; Sort commands according to their usage count.
    (candidate-number-limit . 99999)
    (filtered-candidate-transformer . anything-c-adaptive-sort))
  "Command. (string or symbol)")
  (defvar anything-c-source-extended-command-history-paddy
    '((name . "Emacs Commands History")
      (candidates . extended-command-history)
      (candidate-number-limit . 99999)
      (type . command)))
  (defvar anything-c-source-emacs-commands-paddy
    '((name . "Emacs Commands")
      (candidate-number-limit . 99999)
      (candidates . (lambda ()
                      (let (commands)
                        (mapatoms (lambda (a)
                                    (if (commandp a)
                                        (push (symbol-name a)
                                              commands))))
                        (sort commands 'string-lessp))))
                                        ;(volatile)
;      (requires-pattern . 2) 
      (type . command)))
  (defun paddy-M-x-anything ()
    (interactive)
    (anything  '(anything-c-source-extended-command-history-paddy
                 anything-c-source-emacs-commands-paddy))))


(setq anything-quick-update t)



(defun paddy-info-file (filename)
  ;(interactive (find-file-read-args "Info file: " nil))
  (interactive "f Info File:")
  (info filename))
(define-key anything-map "\C-s" 'anything-isearch)
(define-key anything-map "\C-p" 'anything-previous-line)
(define-key anything-map "\C-n" 'anything-next-line)
(define-key anything-map "\C-v" 'anything-next-page)
(define-key anything-map "\M-v" 'anything-previous-page)

(provide 'anything-config-paddy)