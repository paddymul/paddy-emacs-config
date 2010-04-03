
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
(when (load "flymake" t)
  (defun flymake-pycodecheck-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list pycodechecker (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pycodecheck-init)))

(defun my-flymake-show-help ()
   (when (get-char-property (point) 'flymake-overlay)
     (let ((help (get-char-property (point) 'help-echo)))
       (if help (message "%s" help)))))

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
                ("C-s-n"     flymake-goto-next-error)
                ("C-s-p"     flymake-goto-previous-error)
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

