
;(setenv "PYMACS_PYTHON" "/Library/Frameworks/Python.framework/Versions/Current/bin/python")
(setenv "PYMACS_PYTHON" "/usr/bin/python")


;(load-expand "~/.emacs.d/vendor/pymacs.el")
(load-expand "~/.emacs.d/vendor/pymacs/pymacs.el")
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-global-prefix "C-c r") 
(add-hook 'ropemacs-mode-hook
	  '(lambda ()
             (define-key ropemacs-local-keymap (kbd "M-/") 'dabbrev-expand)
             (define-key ropemacs-local-keymap (kbd "M-,") 'rope-goto-definition)
             (define-key ropemacs-local-keymap (kbd "M-'") 'rope-code-assist)))





(setq py-shell-switch-buffers-on-execute 'nil)


(defun paddy-py-clear-execute-buffer() 
  (interactive)
  (py-clear-queue)
  (py-execute-buffer))

(defun py-paddy-beginning-of-class ()
  (interactive)
  (re-search-backward "^class" nil 't))


(defun py-paddy-end-of-class ()
  (interactive)
  (if (eq last-command 'py-paddy-end-of-class)
      (re-search-forward "^class" nil 't)
    (py-paddy-beginning-of-class ))
  (re-search-forward "^$")) 

;; this regex needs some work
;; code checking via flymake
;; set code checker here from "epylint", "pyflakes"
(setq pycodechecker "pyflakes")
(defun paddy-flymake-create-temp-global (file-name prefix)
    (make-temp-file prefix))
(when (load "flymake" t)
  (defun flymake-pycodecheck-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'paddy-flymake-create-temp-global))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list pycodechecker (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pycodecheck-init)))

(defvar global-markset-nomsg nil)


;; this is redefined so that I can call debug-on-entry on just this function
(defun paddy-mark-message ()
      (message "Mark set"))

;;; This is modified so that I can control markset nomsg globally, so
;;; that I don't have to pass nomsg down through 30 funciton calls

(defun push-mark (&optional location nomsg activate)
  "Set mark at LOCATION (point, by default) and push old mark on mark ring.
If the last global mark pushed was not in the current buffer,
also push LOCATION on the global mark ring.
Display `Mark set' unless the optional second arg NOMSG is non-nil.

Novice Emacs Lisp programmers often try to use the mark for the wrong
purposes.  See the documentation of `set-mark' for more information.

In Transient Mark mode, activate mark if optional third arg ACTIVATE non-nil."
  (unless (null (mark t))
    (setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
    (when (> (length mark-ring) mark-ring-max)
      (move-marker (car (nthcdr mark-ring-max mark-ring)) nil)
      (setcdr (nthcdr (1- mark-ring-max) mark-ring) nil)))
  (set-marker (mark-marker) (or location (point)) (current-buffer))
  ;; Now push the mark on the global mark ring.
  (if (and global-mark-ring
	   (eq (marker-buffer (car global-mark-ring)) (current-buffer)))
      ;; The last global mark pushed was in this same buffer.
      ;; Don't push another one.
      nil
    (setq global-mark-ring (cons (copy-marker (mark-marker)) global-mark-ring))
    (when (> (length global-mark-ring) global-mark-ring-max)
      (move-marker (car (nthcdr global-mark-ring-max global-mark-ring)) nil)
      (setcdr (nthcdr (1- global-mark-ring-max) global-mark-ring) nil)))
  (or nomsg executing-kbd-macro (> (minibuffer-depth) 0) 
      global-markset-nomsg
      (paddy-mark-message))
  (if (or activate (not transient-mark-mode))
      (set-mark (mark t)))
  nil)

(defun flymake-highlight-line (line-no line-err-info-list)
  "Highlight line LINE-NO in current buffer.
Perhaps use text from LINE-ERR-INFO-LIST to enhance highlighting."
  (let ((global-markset-nomsg t))
  (goto-line line-no)
  (let* ((line-beg (flymake-line-beginning-position))
	 (line-end (flymake-line-end-position))
	 (beg      line-beg)
	 (end      line-end)
	 (tooltip-text (flymake-ler-text (nth 0 line-err-info-list)))
	 (face     nil))

    (goto-char line-beg)
    (while (looking-at "[ \t]")
      (forward-char))

    (setq beg (point))

    (goto-char line-end)
    (while (and (looking-at "[ \t\r\n]") (> (point) 1))
      (backward-char))

    (setq end (1+ (point)))

    (when (<= end beg)
      (setq beg line-beg)
      (setq end line-end))

    (when (= end beg)
      (goto-char end)
      (forward-line)
      (setq end (point)))

    (if (> (flymake-get-line-err-count line-err-info-list "e") 0)
	(setq face 'flymake-errline)
      (setq face 'flymake-warnline))

    (flymake-make-overlay beg end tooltip-text face nil))))

;; this is redefined so that global-markset-nomsg is t, I don't want
;; markset things popping up because of flymake stuff


(defun flymake-goto-line (line-no)
  "Go to line LINE-NO, then skip whitespace."
  (let ((global-markset-nomsg t))
  (goto-line line-no)
  (flymake-skip-whitespace)))

(defun my-flymake-show-help ()
   (when (get-char-property (point) 'flymake-overlay)
     (let ((help (get-char-property (point) 'help-echo)))
       (if help (message "%s" help)))))

(defun paddy-flymake-goto-next-error ()
  (interactive)
  (flymake-goto-next-error)
  (my-flymake-show-help))

(defun paddy-flymake-goto-prev-error ()
  (interactive)
  (flymake-goto-prev-error)
  (my-flymake-show-help))

; (add-hook 'post-command-hook 'my-flymake-show-help)

(load-file (expand-file-name "~/.emacs.d/vendor/python-mode.el"))

(defun paddy-local-set-keys (key-list)
  "saves reptition when setting a large number of keybindings "
  (mapcar '(lambda (key-pair) 
             (local-set-key 
              (read-kbd-macro (car key-pair)) 
              (cadr key-pair)))
          key-list))

;(setq python-mode-hook nil)
(add-hook 'python-mode-hook 
          '(lambda () 
             (paddy-local-set-keys 
              '(("C-s-a"     py-paddy-beginning-of-class)
                ("C-s-e"     py-paddy-end-of-class)
                ("C-s-f"     py-fill-paragraph)
                ("C-s-n"     paddy-flymake-goto-next-error)
                ("C-s-p"     paddy-flymake-goto-prev-error)
                ("C-s-/"     flymake-display-err-menu-for-current-line)
                ("C-c C-t"   paddy-py-test-current-file)
                ("C-c r"     paddy-recompile)
                ("C-c C-j"   paddy-py-test-django-full)
                ("C-c C-o"   paddy-py-test-django-working)
                ("C-c C-d"   paddy-py-test-current-tree)
                ;("C-c C-i"   paddy-py-test-integration)
                ;("C-c C-c"   paddy-py-clear-execute-buffer)))
                ))
             ;(ropemacs-mode)
             (flymake-mode)))



;;; for some reason this eventually makes python-mode really slow after a while
(remove-hook 'python-mode-hook 'wisent-python-default-setup)

;(load-expand "~/.emacs.d/vendor/ipython.el")
(setq ipython-command "/usr/bin/ipython") ;/Library/Frameworks/Python.framework/Versions/2.6/bin/ipython")
(setq py-python-command-args '("-pylab" "-colors" "LightBG"))
;(setq py-python-command-args '(""))
(require 'python-mode)
(require 'ipython)
(add-to-list 'auto-mode-alist '("\\.egg\\'" . archive-mode))

;(add-hook 'find-file-hook 'flymake-find-file-hook)

;; utter hack
(load-file (expand-file-name "~/eltesto/eltesto.el"))
(load-file (expand-file-name "~/eltesto/py-testing-commands.el"))

(provide 'paddy-py-config)

