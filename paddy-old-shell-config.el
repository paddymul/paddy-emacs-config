

;(defun to-shell-or-new-shell ()
;  (interactive))
  

(define-derived-mode shell-mode comint-mode "Shell"
  "Major mode for interacting with an inferior shell.\\<shell-mode-map>
\\[comint-send-input] after the end of the process' output sends the text from
    the end of process to the end of the current line.
\\[comint-send-input] before end of process output copies the current line minus the prompt to
    the end of the buffer and sends it (\\[comint-copy-old-input] just copies the current line).
\\[send-invisible] reads a line of text without echoing it, and sends it to
    the shell.  This is useful for entering passwords.  Or, add the function
    `comint-watch-for-password-prompt' to `comint-output-filter-functions'.

If you want to make multiple shell buffers, rename the `*shell*' buffer
using \\[rename-buffer] or \\[rename-uniquely] and start a new shell.

If you want to make shell buffers limited in length, add the function
`comint-truncate-buffer' to `comint-output-filter-functions'.

If you accidentally suspend your process, use \\[comint-continue-subjob]
to continue it.

`cd', `pushd' and `popd' commands given to the shell are watched by Emacs to
keep this buffer's default directory the same as the shell's working directory.
While directory tracking is enabled, the shell's working directory is displayed
by \\[list-buffers] or \\[mouse-buffer-menu] in the `File' field.
\\[dirs] queries the shell and resyncs Emacs' idea of what the current
    directory stack is.
\\[dirtrack-mode] turns directory tracking on and off.

\\{shell-mode-map}
Customization: Entry to this mode runs the hooks on `comint-mode-hook' and
`shell-mode-hook' (in that order).  Before each input, the hooks on
`comint-input-filter-functions' are run.  After each shell output, the hooks
on `comint-output-filter-functions' are run.

Variables `shell-cd-regexp', `shell-chdrive-regexp', `shell-pushd-regexp'
and `shell-popd-regexp' are used to match their respective commands,
while `shell-pushd-tohome', `shell-pushd-dextract' and `shell-pushd-dunique'
control the behavior of the relevant command.

Variables `comint-completion-autolist', `comint-completion-addsuffix',
`comint-completion-recexact' and `comint-completion-fignore' control the
behavior of file name, command name and variable name completion.  Variable
`shell-completion-execonly' controls the behavior of command name completion.
Variable `shell-completion-fignore' is used to initialize the value of
`comint-completion-fignore'.

Variables `comint-input-ring-file-name' and `comint-input-autoexpand' control
the initialization of the input ring history, and history expansion.

Variables `comint-output-filter-functions', a hook, and
`comint-scroll-to-bottom-on-input' and `comint-scroll-to-bottom-on-output'
control whether input and output cause the window to scroll to the end of the
buffer."
  (setq comint-prompt-regexp shell-prompt-pattern)
  (setq comint-completion-fignore shell-completion-fignore)
  (setq comint-delimiter-argument-list shell-delimiter-argument-list)
  (setq comint-file-name-chars shell-file-name-chars)
  (setq comint-file-name-quote-list shell-file-name-quote-list)
  (set (make-local-variable 'comint-dynamic-complete-functions)
       shell-dynamic-complete-functions)
  (set (make-local-variable 'paragraph-separate) "\\'")
  (make-local-variable 'paragraph-start)
  (setq paragraph-start comint-prompt-regexp)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(shell-font-lock-keywords t))
  (make-local-variable 'shell-dirstack)
  (setq shell-dirstack nil)
  (make-local-variable 'shell-last-dir)
  (setq shell-last-dir nil)
  (setq comint-input-autoexpand shell-input-autoexpand)
  ;; This is not really correct, since the shell buffer does not really
  ;; edit this directory.  But it is useful in the buffer list and menus.
  (make-local-variable 'list-buffers-directory)
  (shell-dirtrack-mode 1)
  (setq list-buffers-directory (expand-file-name default-directory))
  ;; shell-dependent assignments.
  (when (ring-empty-p comint-input-ring)
    (let ((shell (file-name-nondirectory (car
		   (process-command (get-buffer-process (current-buffer)))))))
      (setq comint-input-ring-file-name
	    (or (getenv "HISTFILE")
		(cond ((string-equal shell "bash") "~/.bash_history")
		      ((string-equal shell "ksh") "~/.sh_history")
		      (t "~/.history"))))
      (if (or (equal comint-input-ring-file-name "")
	      (equal (file-truename comint-input-ring-file-name)
		     (file-truename "/dev/null")))
	  (setq comint-input-ring-file-name nil))
      ;; Arrange to write out the input ring on exit, if the shell doesn't
      ;; do this itself.
      (if (and comint-input-ring-file-name
	       (string-match shell-dumb-shell-regexp shell))
	  (set-process-sentinel (get-buffer-process (current-buffer))
				#'shell-write-history-on-exit))
      (setq shell-dirstack-query
	    (cond ((string-equal shell "sh") "pwd")
		  ((string-equal shell "ksh") "echo $PWD ~-")
		  (t "dirs")))
      ;; Bypass a bug in certain versions of bash.
      (when (string-equal shell "bash")
        (add-hook 'comint-output-filter-functions
                  'shell-filter-ctrl-a-ctrl-b nil t)
        (add-hook 'comint-preoutput-filter-functions 
                  'paddy-dirtracker  nil t)))
    (comint-read-input-ring t)))

(defun paddy-sync-dirs-on-string (dlstring)
    (let* ((dl dlstring)
	   (dl-len (length dl))
	   (ds '())			; new dir stack
	   (i 0))
      ;(message dl)
      (while (< i dl-len)
	;; regexp = optional whitespace, (non-whitespace), optional whitespace
	(string-match "\\s *\\(\\S +\\)\\s *" dl i) ; pick off next dir
	(setq ds (cons (concat comint-file-name-prefix
			       (substring dl (match-beginning 1)
					  (match-end 1)))
		       ds))
	(setq i (match-end 0)))
      (let ((ds (nreverse ds)))
	(condition-case nil
	    (progn (shell-cd (car ds))
		   (setq shell-dirstack (cdr ds)
			 shell-last-dir (car shell-dirstack))
		   (shell-dirstack-message))
	  (error (message "Couldn't cd"))))))
(defun  shell-dirstack-message () )
(defun paddy-dirtracker (str)
  (if (string-match "\\(EMACS|\\).*\\(|EMACS\\)" str)
        (let ((paddy-whole-string  (substring str (match-beginning 0) (match-end 0))))
;          (message (substring paddy-whole-string 6 (- (length paddy-whole-string) 6)))
          (paddy-sync-dirs-on-string (substring paddy-whole-string 6 (- (length paddy-whole-string) 6)))

          (string-match "\\(EMACS|\\).*\\(|EMACS\\)" str)
         (concat  (substring str 0  (match-beginning 0)) (substring str  (+ 1 (match-end 0)) (length str))))
    str))

(provide 'paddy-old-shell-config)

