
(setenv "PYMACS_PYTHON" "/Library/Frameworks/Python.framework/Versions/Current/bin/python")


(load-file (expand-file-name "~/me/emacs/pymacs.el"))

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



(add-to-list 'load-path (expand-file-name  "~/me/emacs/ecb"))
(require 'ecb)


(if 'nil 
    (progn
      (progn 
        (setq py-shell-hook 'nil)
        (add-hook 'py-shell-hook
                  (lambda ()
                                        ;(py-execute-string "import sys")
                                        ;(py-execute-string "print sys.path")
                    (py-execute-string "from util.shell import *"))))
      (progn
        (setq python-mode-execute-region-hook 'nil)
        (add-hook 'python-mode-execute-region-hook 
                  (lambda ()
                    (py-execute-string "print 'python-mode-execute-region-hook '")
                    (py-execute-string "r_()")))))
  (progn 
    (setq python-mode-hook 'nil)
    (add-hook 'python-mode-hook 
              '(lambda ()
                 (set (make-local-variable 'py-master-file) buffer-file-name)))))



(require 'compile)
;/Library/Frameworks/Python.framework/Versions/2.6/bin/qr_py_tf %s" buffer-file-name) t))

(defun paddy-py-test-current-file ()
  "call the unit_testing framework on the current file"
  (interactive)
  (compile 
     (format "source ~/permalink/env.sh ; /Library/Frameworks/Python.framework/Versions/2.6/bin/qr_py_tf %s" buffer-file-name ) t))





(defun paddy-py-test-current-tree ()
  "look at the current file, continue going up directories until one without a
  __init__.py is found, then add all subdirectories to test suite and run tests
  "
  (interactive)
  (let ((old-compilation-arguments compilation-arguments))
    (setq compilation-arguments t)
    (compile 
     (format "/Library/Frameworks/Python.framework/Versions/2.6/bin/qr_py_tt %s" buffer-file-name ) t)
    (setq compilation-arguments old-compilation-arguments)))

(defun paddy-py-test-integration ()
  "run all unit tests located within unit_testing.integration_tests.test_all_roots
  "
  (interactive)
  (compile 
   " bash -c '/Library/Frameworks/Python.framework/Versions/2.6/bin/python ~/qrgit/qr_site/qr_site/util/unit_testing/integration_tests.py'" t))
;   "/Library/Frameworks/Python.framework/Versions/2.6/bin/qr_py_ti" t))



(defun dj-sv ()
  "start django development server in a compile buffer "
  (interactive)
  (let ((old-compilation-arguments compilation-arguments))

    (if (get-buffer "dj-sv")
        (pop-to-buffer "dj-sv")
      (progn
        (pop-to-buffer 
         (progn
           (setq compilation-arguments t)
           (compile 
            "cd  /Users/patrickmullen/qrgit/code/exit_project_django ; /Library/Frameworks/Python.framework/Versions/2.6/bin/python dev-manage.py runserver 0.0.0.0:8000" t)))
        (setq compilation-arguments old-compilation-arguments)
        (rename-buffer "dj-sv")))))

(defun tc-dj-sv ()
  "start django development server in a compile buffer "
  (interactive)
  (let ((old-compilation-arguments compilation-arguments))

    (if (get-buffer "tc-dj-sv")
        (pop-to-buffer "tc-dj-sv")
      (progn
        (pop-to-buffer 
         (progn
           (setq compilation-arguments t)
           (compile 
            "cd  /Users/patrickmullen/dj_terminalcast ; /Library/Frameworks/Python.framework/Versions/2.6/bin/python manage.py runserver 0.0.0.0:8000" t)))
        (setq compilation-arguments old-compilation-arguments)
        (rename-buffer "tc-dj-sv")))))


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
             (local-set-key (kbd "C-c C-d") 'paddy-py-test-current-tree)

             ;(local-set-key (kbd "C-c C-i") 'paddy-py-test-integration)
             (local-set-key (kbd "C-c C-c") 'paddy-py-clear-execute-buffer)))


(add-hook 'python-mode-hook 
          '(lambda ()
             (ropemacs-mode)
             (flymake-mode)))
(load-file (expand-file-name "~/.emacs.d/vendor/python-mode.el"))
;(setq exec-path (append exec-path "/Library/Frameworks/Python.framework/Versions/2.6/bin/ipython"))

(load-file (expand-file-name "~/me/emacs/ipython.el"))
(setq ipython-command "/Library/Frameworks/Python.framework/Versions/2.6/bin/ipython")
(setq py-python-command-args '("-pylab" "-colors" "LightBG"))
;(setq py-python-command-args '(""))
(require 'python-mode)
(require 'ipython)
(add-to-list 'auto-mode-alist '("\\.egg\\'" . archive-mode))

(add-hook 'find-file-hook 'flymake-find-file-hook)

(provide 'paddy-py-config)

