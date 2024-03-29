(require 'package)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; install use-package if it isn't already installed
(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

;; dependencies
(setq site-dir
      (expand-file-name "site" user-emacs-directory))

(setq settings-dir
      (expand-file-name "settings" user-emacs-directory))

;; load customizations
(add-to-list 'load-path settings-dir)
(add-to-list 'load-path site-dir)

(setq ring-bell-function 'ignore)
;; do not show startup screen or scratch message
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq-default indent-tabs-mode nil)
(setq-default cursor-type 'bar)
(setq-default blink-cursor-blinks 0)
;; show matching parenthesis
(show-paren-mode 1)
;; highlight matching parenthesis after 0 sec
(setq show-paren-delay 0)
(setq multi-term-program "/bin/zsh")
;; bind cmd to meta on mac:
(setq ns-command-modifier 'meta)
;; bind meta to cmd on mac:
(setq ns-alternate-modifier 'super)
;; enable the display of time in the modeline
(display-time-mode 1)
;; show time hh:mm dd/mm
(setq display-time-format "%H:%M %d/%m")
;; do not display system load average
(setq display-time-default-load-average nil)
;; do not show toolbar
(tool-bar-mode -1)
;; do not show scroll bar
(scroll-bar-mode -1)
;; ignore case on file name completion
(setq read-file-name-completion-ignore-case 1)
;; ignore case on buffer completion
(setq read-buffer-completion-ignore-case 1)
;; calendar start day monday
(setq calendar-week-start-day 1)
;; no backups
(setq make-backup-files nil)
;; no .saves files
(setq auto-save-list-file-name nil)
;; no auto save
(setq auto-save-default nil)
;; show marked text, no region when it is not highlighted
(setq transient-mark-mode 1)

;; tab settings
(setq default-tab-width  2)
;; cutting and pasting uses the clipboard
(setq x-select-enable-clipboard t)

;; y and n instead of yes and no
(fset 'yes-or-no-p 'y-or-n-p)

;; move cursor down a single line at the top, bottom, instead of a half of the page
(setq-default scroll-step 1)
(setq-default scroll-conservatively 0)
(setq-default scroll-margin 2)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(global-set-key (kbd "M-l") 'next-multiframe-window)
(global-set-key (kbd "C-x C-m") 'execute-extended-command)
(global-set-key (kbd "C-c C-m") 'execute-extended-command)
(global-set-key (kbd "C-c C-k") 'kill-region)
(global-set-key (kbd "C-k") 'delete-eol-or-region)
(global-set-key (kbd "M-1") 'sr-speedbar-toggle)
(global-set-key (kbd "M-j") 'bs-show)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-h a") 'apropos)
(global-set-key (kbd "M-[") 'backward-up-list)
(global-set-key (kbd "M-]") 'down-list)
;; disable suspend-frame
(global-unset-key (kbd "C-x C-z"))

; Stop Emacs from losing undo information by
; setting very high limits for undo buffers
(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)

(global-set-key (kbd "M-<up>") '(lambda () (interactive) (enlarge-window 1)))
(global-set-key (kbd "M-<down>") '(lambda () (interactive) (enlarge-window -1)))
(global-set-key (kbd "M-<right>") '(lambda () (interactive) (enlarge-window-horizontally 1)))
(global-set-key (kbd "M-<left>") '(lambda () (interactive) (enlarge-window-horizontally -1)))

;; do not yank ever
(global-set-key (kbd "C-w") 'backward-delete-word)
(global-set-key (kbd "M-d") 'delete-word)

(global-set-key (kbd "C->") (
        lambda() (interactive) (next-line) (recenter-top-bottom '(middle))))

(global-set-key (kbd "C-<") (
        lambda() (interactive) (previous-line) (recenter-top-bottom '(middle))))

(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-word (- arg)))

(defun delete-eol-or-region ()
  "Deletes from the caret position until the end of the current line or
deletes the selection."
  (interactive)
   (cond ((use-region-p) (delete-region (region-beginning) (region-end))) ;; if there is a region delete it
         ((eolp)         (delete-char 1))                                 ;; if it is the end of the line - delete \n so the next line is moved to the current line
         (t              (delete-region (point) (line-end-position)))))   ;; delete from the current point to the end of the line

;; plugins

;; https://www.emacswiki.org/emacs/InteractivelyDoThings
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

;; buffer selection
;; https://www.emacswiki.org/emacs/BufferSelection
;; https://github.com/emacs-mirror/emacs/blob/master/lisp/bs.el
(require 'bs)
(setq bs-configurations
      '(("files" "^\\*scratch\\*" nil nil bs-visits-non-file bs-sort-buffer-interns-are-last)))

;; use SrSpeedbar https://www.emacswiki.org/emacs/SrSpeedbar instead of standard
;; speedbar because the latter opens in a different frame.
(require 'sr-speedbar)
;; show all files, not folders only
(setq speedbar-show-unknown-files t)
;; show hidden files
(setq speedbar-directory-unshown-regexp "^$")

(eval-after-load 'dired '(require 'setup-dired))

;; edit rectangles with C-RET
(setq cua-highlight-region-shift-only nil) ;no transient mark mode
(setq cua-toggle-set-mark nil) ;original set-mark behavior, i.e. no transient-mark-mode
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
;; DOESNT WORK: If non-nil, typed text replaces text in the active selection.
;; (setq cua-delete-selection t)
;; I don't need cua keybindings, but rectangle selection only
;; (cua-mode 'emacs)
(cua-selection-mode t)

;; this will search for and load ***-theme.el (light-theme.el) in ~/.config/emacs.
;; t - do not ask permissions every time.
(load-theme 'light t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("0eb866723f81a3a28159505da2616086722328abc7ef118bfc8778f1667964e5" "17adbcb90b1478ea5deef7c659ea4f7d9e6a120f5422fef074d95c938c088f21" "2e76c530f8939d8e269c1f3fcb1c1c4c8e4d15ebd153799b3dba4ab7ae3c1d57" "194ec31c4450ddc1d5e0490dc1eeda783ac5312542a76cdc065381e480eebbe7" "944f86bc721b184a46de9efaa81b4963d95ff77214466570bf9e757d997dd3dc" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
