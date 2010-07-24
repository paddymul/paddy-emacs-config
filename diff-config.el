
(when nil 
(defun ediff-revision (&optional file startup-hooks)
  "Run Ediff by comparing versions of a file.
The file is an optional FILE argument or the file entered at the prompt.
Default: the file visited by the current buffer.
Uses `vc.el' or `rcs.el' depending on `ediff-version-control-package'."
  ;; if buffer is non-nil, use that buffer instead of the current buffer
  (interactive "P")
  (if (not (stringp file))
    (setq file
	  (ediff-read-file-name "Compare revisions for file"
				(if ediff-use-last-dir
				    ediff-last-dir-A
				  default-directory)
				(ediff-get-default-file-name)
				'no-dirs)))
  (find-file file)
  (if (and (buffer-modified-p)
	   (y-or-n-p (format "Buffer %s is modified. Save buffer? "
                             (buffer-name))))
      (save-buffer (current-buffer)))
  (let (rev1 rev2)
    (setq rev1
	  (read-string
	   (format "Revision 1 to compare (default %s's latest revision): "
		   (file-name-nondirectory file)))
	  rev2
	  (read-string
	   (format "Revision 2 to compare (default %s's current state): "
		   (file-name-nondirectory file))))
    (message "rev1")
    (message rev1)
    (ediff-load-version-control)
    (funcall
     (intern (format "ediff-%S-internal" ediff-version-control-package))
     rev1 rev2 startup-hooks)
    ))

(let (rev1
    (funcall
     (intern (format "ediff-%S-internal" ediff-version-control-package))
     rev1 rev2 startup-hooks)))

(defun paddy-diff-master ()
  (interactive)
  (ediff-vc-internal "" "master")))
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)

(provide 'diff-config)