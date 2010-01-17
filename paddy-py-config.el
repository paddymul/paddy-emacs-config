
(setenv "PYMACS_PYTHON" "/Library/Frameworks/Python.framework/Versions/Current/bin/python")


(load-expand "~/.emacs.d/vendor/pymacs.el")
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-global-prefix "C-c r") 
(add-hook 'ropemacs-mode-hook
	  '(lambda ()
             (define-key ropemacs-local-keymap   "\M-/" 'dabbrev-expand)
             (define-key ropemacs-local-keymap   "\M-'" 'rope-code-assist)))



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


(when (load "flymake" t) 
  (defun flymake-pyflakes-init () 
    (let* ((temp-file (flymake-init-create-temp-buffer-copy 
                       'flymake-create-temp-inplace)) 
           (local-file (file-relative-name 
                        temp-file 
                        (file-name-directory buffer-file-name)))) 
      (list "/Library/Frameworks/Python.framework/Versions/2.6/bin/pyflakes" (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks 
               '("\\.py\\'" flymake-pyflakes-init)))

(defun my-flymake-show-help ()
   (when (get-char-property (point) 'flymake-overlay)
     (let ((help (get-char-property (point) 'help-echo)))
       (if help (message "%s" help)))))

; (add-hook 'post-command-hook 'my-flymake-show-help)


(add-hook 'python-mode-hook 
          '(lambda ()
             (local-set-key (kbd "C-H-a") 'py-paddy-beginning-of-class)
             (local-set-key (kbd "C-H-e") 'py-paddy-end-of-class)
             (local-set-key (kbd "C-H-f") 'py-fill-paragraph)
             (local-set-key (kbd "C-H-n") 'flymake-goto-next-error)
             (local-set-key (kbd "C-H-p") 'flymake-goto-previous-error)
             (local-set-key (kbd "C-H-/") 
                            'flymake-display-err-menu-for-current-line)

             (local-set-key (kbd "C-c C-t") 'paddy-py-test-current-file)
             (local-set-key (kbd "C-c r") 'paddy-recompile)
             (local-set-key (kbd "C-c C-j") 'paddy-py-test-django-full)
             (local-set-key (kbd "C-c C-o") 'paddy-py-test-django-working)
             (local-set-key (kbd "C-c C-d") 'paddy-py-test-current-tree)

             ;(local-set-key (kbd "C-c C-i") 'paddy-py-test-integration)
;             (local-set-key (kbd "C-c C-c") 'paddy-py-clear-execute-buffer)
             ))


(add-hook 'python-mode-hook 
          '(lambda ()
             (ropemacs-mode)
             (flymake-mode)
             ))
(load-file (expand-file-name "~/.emacs.d/vendor/python-mode.el"))
;(setq exec-path (append exec-path "/Library/Frameworks/Python.framework/Versions/2.6/bin/ipython"))


(load-expand "~/.emacs.d/vendor/ipython.el")
(setq ipython-command "/Library/Frameworks/Python.framework/Versions/2.6/bin/ipython")
(setq py-python-command-args '("-pylab" "-colors" "LightBG"))
;(setq py-python-command-args '(""))
(require 'python-mode)
(require 'ipython)
(add-to-list 'auto-mode-alist '("\\.egg\\'" . archive-mode))

;(add-hook 'find-file-hook 'flymake-find-file-hook)

(provide 'paddy-py-config)

