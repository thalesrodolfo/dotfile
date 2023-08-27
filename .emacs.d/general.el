;; -----------------------------
;; GENERAL CONFIG
;; -----------------------------

(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(setq custom-file (concat user-emacs-directory "/custom.el"))
(load-file "~/.emacs.d/custom.el")

;; disable initial screen
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

; disable beep sound
(setq ring-bell-function 'ignore)

; disable emacs default interface
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

; enable ovewrite selected text
(delete-selection-mode 1)

; disble backup files
(setq make-backup-files nil)

;; -----------------------------
