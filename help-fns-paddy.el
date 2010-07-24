
(defun help-paddy-goto-function (function)
  "Display the full documentation of FUNCTION (a symbol)."
  (interactive
   (let ((fn (function-called-at-point))
	 (enable-recursive-minibuffers t)
	 val)
     (setq val (completing-read (if fn
				    (format "Goto function (default %s): " fn)
				  "Goto function: ")
				obarray 'fboundp t nil nil
				(and fn (symbol-name fn))))
     (list (if (equal val "")
	       fn (intern val)))))
  (if (null function)
      (message "You didn't specify a function")
    (help-setup-xref (list #'describe-function function) (interactive-p))
   	(help-paddy-goto-function-1 function)
        ))


(defun help-paddy-goto-function-1 (function)
  (let* ((def (if (symbolp function)
		  (symbol-function function)
		function))
	 file-name string)
    (or file-name
	(setq file-name (symbol-file function 'defun)))
    (setq file-name (describe-simplify-lib-file-name file-name))
      (if file-name
	  (help-paddy-goto-el-file function file-name)
        (message "couldn't find the filename for the function"))))

(defun help-paddy-goto-el-file (fun file)
	   (require 'find-func)
		   (when (eq file 'C-source)
		     (setq file
			   (help-C-file-name (indirect-function fun) 'fun)))
		   ;; Don't use find-function-noselect because it follows
		   ;; aliases (which fails for built-in functions).
		   (let ((location
			  (find-function-search-for-symbol fun nil file)))
		     (pop-to-buffer (car location))
		     (if (cdr location)
			 (goto-char (cdr location))
		       (message "Unable to find location in file"))))
;;;###autoload
(defun describe-function-asdf (function)
  (let* ((def (if (symbolp function)
		  (symbol-function function)
		function))
	 file-name string
	 (beg (if (commandp def) "an interactive " "a ")))
    (setq string
	  (cond ((or (stringp def)
		     (vectorp def))
		 "a keyboard macro")
		((subrp def)
		 (if (eq 'unevalled (cdr (subr-arity def)))
		     (concat beg "special form")
		   (concat beg "built-in function")))
		((byte-code-function-p def)
		 (concat beg "compiled Lisp function"))
		((symbolp def)
		 (while (symbolp (symbol-function def))
		   (setq def (symbol-function def)))
		 (format "an alias for `%s'" def))
		((eq (car-safe def) 'lambda)
		 (concat beg "Lisp function"))
		((eq (car-safe def) 'macro)
		 "a Lisp macro")
		((eq (car-safe def) 'autoload)
		 (setq file-name (nth 1 def))
		 (format "%s autoloaded %s"
			 (if (commandp def) "an interactive" "an")
			 (if (eq (nth 4 def) 'keymap) "keymap"
			   (if (nth 4 def) "Lisp macro" "Lisp function"))
			 ))
                ((keymapp def)
                 (let ((is-full nil)
                       (elts (cdr-safe def)))
                   (while elts
                     (if (char-table-p (car-safe elts))
                         (setq is-full t
                               elts nil))
                     (setq elts (cdr-safe elts)))
                   (if is-full
                       "a full keymap"
                     "a sparse keymap")))
		(t "")))
    (princ string)
    (with-current-buffer standard-output
      (save-excursion
	(save-match-data
	  (if (re-search-backward "alias for `\\([^`']+\\)'" nil t)
	      (help-xref-button 1 'help-function def)))))
    (or file-name
	(setq file-name (symbol-file function 'defun)))
    (setq file-name (describe-simplify-lib-file-name file-name))
    (when (equal file-name "loaddefs.el")
      ;; Find the real def site of the preloaded function.
      ;; This is necessary only for defaliases.
      (let ((location
	     (condition-case nil
		 (find-function-search-for-symbol function nil "loaddefs.el")
	       (error nil))))
	(when location
	  (with-current-buffer (car location)
	    (goto-char (cdr location))
	    (when (re-search-backward
		   "^;;; Generated autoloads from \\(.*\\)" nil t)
	      (setq file-name (match-string 1)))))))
    (when (and (null file-name) (subrp def))
      ;; Find the C source file name.
      (setq file-name (if (get-buffer " *DOC*")
			  (help-C-file-name def 'subr)
			'C-source)))
    (when file-name
      (princ " in `")
      ;; We used to add .el to the file name,
      ;; but that's completely wrong when the user used load-file.
      (princ (if (eq file-name 'C-source) "C source code" file-name))
      (princ "'")
      ;; Make a hyperlink to the library.
      (with-current-buffer standard-output
        (save-excursion
	  (re-search-backward "`\\([^`']+\\)'" nil t)
	  (help-xref-button 1 'help-function-def function file-name))))
    (princ ".")
    (terpri)
    (when (commandp function)
      (if (and (eq function 'self-insert-command)
	       (eq (key-binding "a") 'self-insert-command)
	       (eq (key-binding "b") 'self-insert-command)
	       (eq (key-binding "c") 'self-insert-command))
	  (princ "It is bound to many ordinary text characters.\n")
	(let* ((remapped (command-remapping function))
	       (keys (where-is-internal
		      (or remapped function) overriding-local-map nil nil))
	       non-modified-keys)
	  ;; Which non-control non-meta keys run this command?
	  (dolist (key keys)
	    (if (member (event-modifiers (aref key 0)) '(nil (shift)))
		(push key non-modified-keys)))
	  (when remapped
	    (princ "It is remapped to `")
	    (princ (symbol-name remapped))
	    (princ "'"))

	  (when keys
	    (princ (if remapped " which is bound to " "It is bound to "))
	    ;; If lots of ordinary text characters run this command,
	    ;; don't mention them one by one.
	    (if (< (length non-modified-keys) 10)
		(princ (mapconcat 'key-description keys ", "))
	      (dolist (key non-modified-keys)
		(setq keys (delq key keys)))
	      (if keys
		  (progn
		    (princ (mapconcat 'key-description keys ", "))
		    (princ ", and many ordinary text characters"))
		(princ "many ordinary text characters"))))
	  (when (or remapped keys non-modified-keys)
	    (princ ".")
	    (terpri)))))
    (let* ((arglist (help-function-arglist def))
	   (doc (documentation function))
	   (usage (help-split-fundoc doc function)))
      (with-current-buffer standard-output
        ;; If definition is a keymap, skip arglist note.
        (unless (keymapp def)
          (let* ((use (cond
                        (usage (setq doc (cdr usage)) (car usage))
                        ((listp arglist)
                         (format "%S" (help-make-usage function arglist)))
                        ((stringp arglist) arglist)
                        ;; Maybe the arglist is in the docstring of the alias.
                        ((let ((fun function))
                           (while (and (symbolp fun)
                                       (setq fun (symbol-function fun))
                                       (not (setq usage (help-split-fundoc
                                                         (documentation fun)
                                                         function)))))
                           usage)
                         (car usage))
                        ((or (stringp def)
                             (vectorp def))
                         (format "\nMacro: %s" (format-kbd-macro def)))
                        (t "[Missing arglist.  Please make a bug report.]")))
                 (high (help-highlight-arguments use doc)))
            (let ((fill-begin (point)))
	      (insert (car high) "\n")
	      (fill-region fill-begin (point)))
            (setq doc (cdr high))))
        (let ((obsolete (and
                         ;; function might be a lambda construct.
                         (symbolp function)
                         (get function 'byte-obsolete-info))))
          (when obsolete
            (princ "\nThis function is obsolete")
            (when (nth 2 obsolete)
              (insert (format " since %s" (nth 2 obsolete))))
            (insert ";\n"
                    (if (stringp (car obsolete)) (car obsolete)
                      (format "use `%s' instead." (car obsolete)))
                    "\n"))
          (insert "\n"
                  (or doc "Not documented."))
              (insert "\n\n SOURCE \n\n"
                      (help-paddy-get-function-source function file-name)))))))


(defun help-paddy-get-function-source (fun file)
	   (require 'find-func)
		   (when (eq file 'C-source)
		     (setq file
			   (help-C-file-name (indirect-function fun) 'fun)))
		   ;; Don't use find-function-noselect because it follows
		   ;; aliases (which fails for built-in functions).
		   (let ((location
			  (find-function-search-for-symbol fun nil file)))
                     (save-excursion
                       (let ((fn-buf (car location))
                             (fn-char-begin (cdr location)))
                       (pop-to-buffer fn-buf)
                        ;(message location)     
                        (if fn-char-begin
                           (progn 
                             (goto-char fn-char-begin)
                             (end-of-defun)
                             (filter-buffer-substring fn-char-begin (point))))
                        "no source " ))))

(provide 'help-fns-paddy)

