(load-file "~/.emacs.d/general.el")
(load-file "~/.emacs.d/themes.el")

;; -----------------------------
;; INTERFACE CONFIG
;; -----------------------------

;; font
;;(add-to-list 'default-frame-alist '(font . "Maple Mono-14"))
(set-face-attribute 'default nil ':font "Maple Mono" ':height 130)

;; theme
(load-theme 'modus-operandi)
;;(load-theme 'anisochromatic t))

;; -----------------------------
;; LANGUAGES CONFIG
;; -----------------------------

(use-package go-mode
  :ensure t
  :hook (
	 (before-save . lsp-format-buffer)
	 (before-save . lsp-organize-imports)
	 )
  )

;; call import package (if missing) when saving
(defun my-eglot-organize-imports () (interactive)
  (eglot-code-actions nil nil "source.organizeImports" t))

(use-package eglot
  :bind
  (("M-RET" . eglot-code-actions)
  ("<f12>" . eglot-find-typeDefinition)
  ("<f2>" . eglot-rename))
  :hook
  (scala-mode . eglot-ensure)
  (typescript-mode . eglot-ensure)
  (python-mode . eglot-ensure)
  (go-mode . eglot-ensure)
  (f90-mode . eglot-ensure)
  (zig-mode . eglot-ensure)
  (before-save . my-eglot-organize-imports)
  (before-save . eglot-format-buffer)
  :config (setq lsp-prefer-flymake nil))

(use-package sideline
  :hook (flymake-mode . sideline-mode)
  :init
  (setq sideline-flymake-display-mode 'point) ; 'point to show errors only on point
                                              ; 'line to show errors on the current line
  (setq sideline-backends-right '(sideline-flymake)))

;; -----------------------------
;; -----------------------------
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))


(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :after vertico
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))


(use-package consult
  :ensure t
  :bind (
	 ("C-s" . consult-line)
	 ("C-x b" . consult-buffer)
	 ("C-x p b" . consult-project-buffer)
	 )
  :hook (completion-list-mode . consult-preview-at-point-mode)
  )


(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
	 ("C-<" . mc/mark-previous-like-this)))

(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-auto-delay 0)
  (corfu-auto-prefix 1)
  (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-popupinfo-mode t)				;
  (corfu-popupinfo-delay 0)
)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))



(use-package magit
  :ensure t)

