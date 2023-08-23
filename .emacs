;;; package -- Summary
;;; Commentary:
(require 'package)

;;; Code:
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
			  ("org" . "https://orgmode.org/elpa/")
))


(package-initialize)

; Fetch the list of packages available
(unless package-archive-contents (package-refresh-contents))

; Install use-package
(setq package-list '(use-package))
(dolist (package package-list)
  (unless (package-installed-p package) (package-install package)))

(require 'use-package)


(setq use-package-always-defer t
      use-package-always-ensure t
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))


(setq default-directory "F:/dev/")


;;(add-to-list 'load-path "~/.emacs.d/")
;;(load "myplugin.el")

(add-to-list 'load-path (concat user-emacs-directory "lisp/" ))

;;(load "odin-mode.el") ;; best not to include the ending “.el” or “.elc”

;;(require 'odin-mode)
;;(add-to-list 'auto-mode-alist '("\\.odin\\'" . odin-mode))

(global-set-key (kbd "C-c C-c") 'compile)
(global-set-key (kbd "M-s") 'save-buffer)
(global-set-key (kbd "M-RET") 'lsp-execute-code-action)
(global-set-key (kbd "C-c l d") 'lsp-ui-doc-show)


(use-package magit
  :ensure t
)

(use-package which-key
  :init
  (setq which-key-idle-delay 2.0
        which-key-idle-secondary-delay 1.0)
  :config
  (which-key-mode))

(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
		 ("C-<" . mc/mark-previous-like-this)))

;; maybe should I put this in lsp-mode?
(use-package go-mode
  :ensure t
  :hook (
		 (before-save . lsp-format-buffer)
		 (before-save . lsp-organize-imports)
		 )
  ;; :init
  ;; (add-hook 'before-save-hook #'lsp-format-buffer)
  ;; (add-hook 'before-save-hook #'lsp-organize-imports)
  )

(use-package smart-mode-line
  :config
  (setq sml/no-confirm-load-theme t
        sml/shorten-directory t
        sml/shorten-modes t
        sml/name-width 50
        sml/mode-width 'full
        sml/theme 'respectful)
  (sml/setup))

(use-package js
  :bind (:map js-mode-map
         ([remap js-find-symbol] . xref-find-definitions))
  :init
  (setq js-indent-level 4))

;; Enable sbt mode for executing sbt commands
(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
   ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
   (setq sbt:program-options '("-Dsbt.supershell=false"))
)

;;(use-package exec-path-from-shell :ensure t)
;;(exec-path-from-shell-initialize)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;;(use-package yasnippet)
(yas-global-mode)

(use-package dap-mode
  :ensure t
  :after (lsp-mode)
  :functions dap-hydra/nil
  :config
  (require 'dap-java)
  :bind (:map lsp-mode-map
         ("<f5>" . dap-debug)
         ("M-<f5>" . dap-hydra))
  :hook ((dap-mode . dap-ui-mode)
    (dap-session-created . (lambda (&_rest) (dap-hydra)))
    (dap-terminated . (lambda (&_rest) (dap-hydra/nil)))))

(use-package dap-java :ensure nil)

(use-package lsp-treemacs
  :after (lsp-mode treemacs)
  :ensure t
  :commands lsp-treemacs-errors-list
  :bind (:map lsp-mode-map
         ("M-9" . lsp-treemacs-errors-list)))

(use-package treemacs
  :ensure t
  :commands (treemacs)
  :after (lsp-mode))

(use-package lsp-ui
:ensure t
:after (lsp-mode)
:bind (("C-c d" . lsp-ui-doc-show)
	   :map lsp-ui-mode-map
         ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
         ([remap xref-find-references] . lsp-ui-peek-find-references))
:init (setq lsp-ui-doc-delay 1.5
			lsp-ui-doc-position 'at-point
			lsp-ui-doc-show-with-mouse nil
			lsp-ui-doc-max-width 100
			lsp-ui-sideline-show-code-actions t
))

(setq lsp-enable-snippet nil)
(setq company-lsp-enable-snippet nil)

(use-package lsp-mode
:ensure t
:hook (
   (lsp-mode . lsp-enable-which-key-integration)
   (lsp-mode . lsp-lens-mode)
   ((java-mode go-mode scala-mode) . lsp)
)
:init (setq
    lsp-keymap-prefix "C-c l"              ; this is for which-key integration documentation, need to use lsp-mode-map
    lsp-enable-file-watchers nil
    read-process-output-max (* 1024 1024)  ; 1 mb
    lsp-completion-provider :capf
    lsp-idle-delay 0.500
)
:config
    (setq lsp-intelephense-multi-root nil) ; don't scan unnecessary projects
    (with-eval-after-load 'lsp-intelephense
    (setf (lsp--client-multi-root (gethash 'iph lsp-clients)) nil))
	(define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
	(setq lsp-prefer-flymake nil)
)


(use-package lsp-java
:ensure t
:config (add-hook 'java-mode-hook 'lsp))

;; Disable annoying ring-bell when backspace key is pressed in certain situations
(setq ring-bell-function 'ignore)

;; Disable scrollbar and toolbar
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Set language environment to UTF-8
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Longer whitespace, otherwise syntax highlighting is limited to default column
(setq whitespace-line-column 1000) 

;; Enable soft-wrap
(global-visual-line-mode 1)

;; Maintain a list of recent files opened
(recentf-mode 1)            
(setq recentf-max-saved-items 50)

;; Coding specific setting

;; Automatically add ending brackets and braces
(electric-pair-mode 1)

;; Make sure tab-width is 4 and not 8
(setq-default tab-width 4)

;; Highlight matching brackets and braces
(show-paren-mode 1) 

(add-to-list 'default-frame-alist '(font . "Maple Mono-15"))
;;(add-to-list 'default-frame-alist '(font . "Mononoki-15"))
;;(add-to-list 'default-frame-alist '(font . "Dank Mono Regular-16"))

(defun my/ansi-colorize-buffer ()
(let ((buffer-read-only nil))
(ansi-color-apply-on-region (point-min) (point-max))))

(use-package ansi-color
:ensure t
:config
(add-hook 'compilation-filter-hook 'my/ansi-colorize-buffer)
)

(use-package projectile 
:ensure t
:init (projectile-mode +1)
:config 
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
)   

(use-package avy 
:ensure t)

(use-package quickrun 
:ensure t
:bind ("C-c r" . quickrun))

;; Use this parameter in pod-mode
(quickrun-add-command "go/go"
  '((:command . "go")
    (:exec    . "%c run ."))
  :override t)

(use-package use-package-chords
:ensure t
:init 
:config (key-chord-mode 1)
(setq key-chord-two-keys-delay 0.4)
(setq key-chord-one-key-delay 0.5) ; default 0.2
)

(use-package lsp-treemacs)
(use-package hydra)

(use-package swiper
  :ensure t
  :init)

(use-package counsel
  :ensure t
  :init)


(use-package ivy
  :ensure t
  :init
  :bind (
		 ("\C-s" . swiper)
		 ("C-c C-r" . ivy-resume)
		 ("<f6>" . ivy-resume)
		 ("M-x" . counsel-M-x)
		 ("C-x C-f" . counsel-find-file)
		 ("<f1> f" . counsel-describe-function)
		 ("<f1> v" . counsel-describe-variable)
		 ("<f1> o" . counsel-describe-symbol)
		 ("<f1> l" . counsel-find-library)
		 ("<f2> i" . counsel-info-lookup-symbol)
		 ("<f2> u" . counsel-unicode-char)
		 ("C-c g" . counsel-git)
		 ("C-c j" . counsel-git-grep)
		 ("C-c k" . counsel-ag)
		 ("C-x l" . counsel-locate)
		 )
  :config
  (ivy-mode 1)
  )



  

;;; .emacs ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2a2426" "#e68183" "#87af87" "#d9bb80" "#89beba" "#e68183" "#87c095" "#e6d6ac"])
 '(chart-face-color-list
   '("#b52c2c" "#0fed00" "#f1e00a" "#2fafef" "#bf94fe" "#47dfea" "#702020" "#007800" "#b08940" "#1f2f8f" "#5f509f" "#00808f"))
 '(custom-safe-themes
   '("ddb9bc949afc4ead71a8861e68ad364cd3c512890be51e23a34e4ba5a18b0ade" "5014b68d3880d21a5539af6ef40c1e257e9045d224efb3b65bf0ae7ff2a5e17a" "13bf32d92677469e577baa02d654d462f074c115597652c1a3fce6872502bbea" "df2cdf4ffb933c929b6a95d60ac375013335b61565b9ebf02177b86e5e4d643f" "76c646974f43b321a8fd460a0f5759f916654575da5927d3fd4195029c158018" "3ca84532551daa1b492545bbfa47fd1b726ca951d8be29c60a3214ced30b86f5" "b9761a2e568bee658e0ff723dd620d844172943eb5ec4053e2b199c59e0bcc22" "9d29a302302cce971d988eb51bd17c1d2be6cd68305710446f658958c0640f68" "4af38f1ae483eb9335402775b02e93a69f31558f73c869af0d2403f1c72d1d33" default))
 '(exwm-floating-border-color "#5b5b5b")
 '(fci-rule-color "#7c6f64")
 '(flymake-error-bitmap '(flymake-double-exclamation-mark ef-themes-mark-delete))
 '(flymake-note-bitmap '(exclamation-mark ef-themes-mark-select))
 '(flymake-warning-bitmap '(exclamation-mark ef-themes-mark-other))
 '(highlight-tail-colors ((("#33312f" "#33312f") . 0) (("#333331" "#333331") . 20)))
 '(ibuffer-deletion-face 'ef-themes-mark-delete)
 '(ibuffer-filter-group-name-face 'bold)
 '(ibuffer-marked-face 'ef-themes-mark-select)
 '(ibuffer-title-face 'default)
 '(jdee-db-active-breakpoint-face-colors (cons "#0d1011" "#d9bb80"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#0d1011" "#87af87"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#0d1011" "#5b5b5b"))
 '(linum-format "%3i")
 '(objed-cursor-color "#e68183")
 '(package-selected-packages
   '(magit smart-mode-line multiple-cursors zig-mode yasnippet-snippets which-key use-package-chords twilight-bright-theme sbt-mode rust-mode quickrun projectile nano-theme lsp-ui lsp-metals lsp-java lsp-haskell helm-lsp helm-descbinds heaven-and-hell go-mode flymake-haskell-multi flycheck-golangci-lint exec-path-from-shell elixir-mode ef-themes doom-themes counsel company cargo bubbleberry-theme))
 '(pdf-view-midnight-colors (cons "#e6d6ac" "#2a2426"))
 '(powerline-color1 "#3d3d68")
 '(powerline-color2 "#292945")
 '(rustic-ansi-faces
   ["#2a2426" "#e68183" "#87af87" "#d9bb80" "#89beba" "#e68183" "#87c095" "#e6d6ac"])
 '(vc-annotate-background "#2a2426")
 '(vc-annotate-color-map
   (list
	(cons 20 "#87af87")
	(cons 40 "#a2b384")
	(cons 60 "#bdb682")
	(cons 80 "#d9bb80")
	(cons 100 "#dcb07e")
	(cons 120 "#dfa57c")
	(cons 140 "#e39b7b")
	(cons 160 "#e3927d")
	(cons 180 "#e48980")
	(cons 200 "#e68183")
	(cons 220 "#e68183")
	(cons 240 "#e68183")
	(cons 260 "#e68183")
	(cons 280 "#c37779")
	(cons 300 "#a06e6f")
	(cons 320 "#7d6465")
	(cons 340 "#7c6f64")
	(cons 360 "#7c6f64")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
