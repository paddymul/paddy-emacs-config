;;visual customizations
(show-paren-mode)
(column-number-mode)
(modify-syntax-entry ?\_ "w"  c-mode-syntax-table)
(transient-mark-mode -5)
(put 'narrow-to-region 'disabled nil)
(global-font-lock-mode t)
(setq visible-bell t) ;; No beeping

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
(read-abbrev-file (expand-file-name "~/me/emacs/.abbrev_defs"))
(load-file (expand-file-name "~/me/emacs/highlight-current-line.el"))
(require 'highlight-current-line)

(provide 'paddy-global)