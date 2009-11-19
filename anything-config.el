


(setq anything-sources `(((name . "Buffers")
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
                             (candidates . (lambda ()
      (if (and
           (not (equal (substring anything-default-directory 0 5) "/ssh:"))
           (not (equal (substring anything-default-directory 0 6) "/root@")))
          (directory-files anything-default-directory))))

                             (type . file) )

                           ((name . "Manual Pages")
                            (candidates . ,(progn
                                             ;; XEmacs doesn't have a woman :)
                                             (declare (special woman-file-name
                                                               woman-topic-all-completions))
                                             (condition-case nil
                                                 (progn
                                                   (require 'woman)
                                                   (woman-file-name "")
                                                   (sort (mapcar 'car
                                                                 woman-topic-all-completions)
                                                         'string-lessp))
                                               (error nil))))
                            (action . (("Open Manual Page" . woman)))
                            (requires-pattern . 2))

                           ((name . "Complex Command History")
                            (candidates . (lambda ()
                                            (mapcar 'prin1-to-string
                                                    command-history)))
                            (action . (("Repeat Complex Command" . 
                                        (lambda (c)
                                          (eval (read c))))))
                            (delayed))))
(define-key anything-map "\C-s" 'anything-isearch)
(define-key anything-map "\C-p" 'anything-previous-line)
(define-key anything-map "\C-n" 'anything-next-line)
(define-key anything-map "\C-v" 'anything-next-page)
(define-key anything-map "\M-v" 'anything-previous-page)

