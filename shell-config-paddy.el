
;; Add color to a shell running in emacs 'M-x shell'
(require 'term)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


(defun buffer-exists (buff-name)
  (find buff-name (mapcar 'buffer-name (buffer-list)) :test 'equal))

(defun prompt-for-shell-name (shell-name)
  (interactive "s what do you want to name your new shell? ")
  (shell-with-name shell-name))
(defun shell-with-name (shell-name)
  "we only want to run this if both buffers exist"
  (if (and (buffer-exists "*shell*")
           (not (buffer-exists shell-name)))
      (progn
        (switch-to-buffer "*shell*")
        (rename-buffer "temp-shell-*******")
        (shell)
        (rename-buffer shell-name)
        (switch-to-buffer "temp-shell-*******")
        (rename-buffer "*shell*")
        (switch-to-buffer shell-name))))



(defun paddy-shell-previous-prompt() 
  " a bit of a hack, but this ignores pdb, sql, and python prompts "
  (interactive)
  (search-backward ") $")
  (forward-char 4))

(defun paddy-shell-next-prompt() 
  " a bit of a hack, but this ignores pdb, sql, and python prompts "
  (interactive)
  (search-forward ") $")
  (forward-char 4))

(defun new-shell ()
  (interactive)
  (if (string-equal (buffer-name) "*shell*")
        (command-execute 'prompt-for-shell-name)
      (shell)))

(defun perma-sh ()
  (interactive)
  (if (not (buffer-exists "perma-sh"))
      (progn
        (compile "cd ~/permalink ; while [ 1 -lt 5 ]; do . env.sh ; python permalink/manage.py  runserver 0.0.0.0:8000 ; sleep 5; done" t)
        (switch-to-buffer "*compilation*")
        (rename-buffer "perma-sh")
        (bury-buffer))))

(defun dumb-sh ()
  (interactive)
  (if (not (buffer-exists "dumb-sh"))
      (progn
        (compile "cd ~/permalink ; while [ 1 -lt 5 ]; do  . env.sh ; python pp/proxy/dumbsite/manage.py  runserver 0.0.0.0:8003 ; sleep 5; done" t)
        (switch-to-buffer "*compilation*")
        (rename-buffer "dumb-sh")
        (bury-buffer)
        )))

(defun swf-test-sh ()
  (interactive)
  (if (not (buffer-exists "swf-test-sh"))
      (progn
        (compile "cd ~/permalink/lib/swf_rewrite/tests/test_server; while [ 1 -lt 5 ];do python manage.py  runserver 0.0.0.0:8002 ; sleep 1; done" t)
        (switch-to-buffer "*compilation*")
        (rename-buffer "swf-test-sh")
        (bury-buffer)
        )))


(defun ret3-sh ()
  (interactive)
  (if (not (buffer-exists "ret3-sh"))
      (progn
        (compile "cd ~/permalink ; while [ 1 -lt 5 ]; do . env.sh ; python pp/retrieval_record/manage.py  runserver 0.0.0.0:8001 ; sleep 5; done" t)
        (switch-to-buffer "*compilation*")
        (rename-buffer "ret3-sh")
        (bury-buffer))))

(defun idb-ret3-sh ()
  (interactive)
  (if (not (buffer-exists "idb-ret3-sh"))
      (progn
        (compile "cd ~/permalink ; while [ 1 -lt 5 ]; do . env.sh ; python pp/idb_retrieval_record/manage.py  runserver 0.0.0.0:8103 ; sleep 5; done" t)
        (switch-to-buffer "*compilation*")
        (rename-buffer "idb-ret3-sh")
        (bury-buffer))))



(defun solr-sh ()
  (interactive)
  (if (not (buffer-exists "solr-sh"))
      (progn
        (compile "cd ~/permalink ;  . env.sh ;  nohup ppy_solr start   ; " t)
        (switch-to-buffer "*compilation*")
        (rename-buffer "solr-sh")
        (bury-buffer))))





(add-hook 'shell-mode-hook 
   '(lambda ()
      ;(define-key shell-mode-map   (kbd "C-M-a")  'comint-previous-prompt)
      ;(define-key shell-mode-map   (kbd "C-M-e")  'comint-next-prompt)
      (define-key shell-mode-map   (kbd "C-M-a")  'paddy-shell-previous-prompt)
      (define-key shell-mode-map   (kbd "C-M-e")  'paddy-shell-next-prompt)
))





;; Nice shell features. 
(add-hook 'shell-mode-hook 'n-shell-mode-hook)
(defun n-shell-mode-hook ()
  "Shell mode customizations."
  (local-set-key '[up] 'n-shell-up1line)
  (local-set-key '[down] 'n-shell-down1ine)
					;  (local-set-key '[(shift tab)] 'comint-next-matching-input-from-input)
					; (setq comint-input-sender 'n-shell-simple-send)
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



(defun prompt-for-shell-name (shell-name)
  (interactive "s what do you want to name your new shell? ")
  (switch-to-buffer "*shell*")
  (rename-buffer "temp-shell-*******")
  (shell)
  (rename-buffer shell-name)
  (switch-to-buffer "temp-shell-*******")
  (rename-buffer "*shell*")
  (switch-to-buffer shell-name))

(defun paddy-insert-html-into-buffer (url)
  (interactive "s what url do you want to get: ")
  (switch-to-buffer url)
  (html-mode)
  (shell-command (format "curl --stderr /dev/null %s " url) (current-buffer)))

(defun paddy-tidy ()
  (interactive) 
  (shell-command-on-region 1 (buffer-size) "tidy -q -f /dev/null -i" t t))

(defun paddy-js-tidy ()
  (interactive) 
  (shell-command-on-region 1 (buffer-size) "py-js-beautify.py" t t)
  (js2-mode))


;;(shell)
;;(perma-sh)                              
;;(dumb-sh)
;;(swf-test-sh)

(provide 'shell-config-paddy)
