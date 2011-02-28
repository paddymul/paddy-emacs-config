
;;visual customizations
(show-paren-mode)
(column-number-mode)
(modify-syntax-entry ?\_ "w"  c-mode-syntax-table)
(transient-mark-mode -5)
(put 'narrow-to-region 'disabled nil)
(global-font-lock-mode t)
(setq visible-bell t) ;; No beeping

(progn
(defun emacs-temp-join (extra-dir-name)
  (let ((temp-dir-name (concat   
			(expand-file-name "~/.emacs.d/emacs-temp")
                        extra-dir-name)))
    (make-directory temp-dir-name t)
    temp-dir-name))
(defvar autosave-dir
  (emacs-temp-join "emacs_autosaves/"))

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
          (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
            (expand-file-name
             (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (emacs-temp-join "emacs_backups/"))
(setq backup-directory-alist (list (cons "." backup-dir))))


(set-face-foreground 'default "green")
(set-face-background 'default "black")


(defgroup hl-line nil
  "Highlight the current line."
  :version "21.1"
  :group 'editing)

(defcustom hl-line-face 'highlight
  "Face with which to highlight the current line."
  :type 'face
  :group 'hl-line)

(defvar hl-line-overlay nil)
;(set-background-color "black")
;(set-foreground-color "green")


;;editting customizations
(put 'upcase-region 'disabled nil)
(fset 'yes-or-no-p 'y-or-n-p)
(setq x-select-enable-clipboard t)

;; fixes the tab problem with mysql command line client  -- sadly sets spaces system wide
;; I guess I will be a space person
(setq-default indent-tabs-mode nil)
(read-abbrev-file (expand-file-name "~/.emacs.d/.abbrev_defs"))

(defun load-expand (filename)
  (load-file (expand-file-name filename)))

;(require 'highlight-current-line)
(load-expand "~/.emacs.d/vendor/random/display-buffer-for-widescreen.el")
(require 'display-buffer-for-wide-screen)
;(global-linum-mode)
(defun paddy-put-buffer-filename-in-killring ()
  (interactive)
  (kill-new buffer-file-name))

(provide 'global-paddy-config)
