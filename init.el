
;; no startup message
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; disable visible scrollbar
(tool-bar-mode -1)          ; disable the toolbar
(tooltip-mode -1)           ; disable tooltips
(set-fringe-mode 10)        ; give some breathing room

(menu-bar-mode -1)          ; disable menu bar

(set-face-attribute 'default nil :height 120)


;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources
(require 'package)

(setq package-archives '(
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
			 
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/")t)

(package-initialize)
;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package t))

(require 'use-package)
(setq use-package-always-ensure t)
(unless package-archive-contents
  (package-refresh-contents))
  
;; fonts
(use-package all-the-icons
  :if (display-graphic-p))

;; line numbers
(column-number-mode)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook
		shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;;;;;;;;;;;;;;;;;;;;; PACKAGES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package company)
(use-package yasnippet-snippets)
(add-hook 'after-init-hook 'global-company-mode)

;; treemacs
(use-package treemacs
  :ensure t)


(use-package treemacs-evil
  :ensure t)

;; javascript
(use-package js2-mode
  :ensure t)
(add-to-list 'auto-mode-alist (cons (rx ".js" eos) 'js2-mode))

;; python
(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))

;; haskell
(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)


;; web-mode
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode)) ;; auto-enable for .js/.jsx files
(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
(use-package web-mode
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook `emmet-mode)


;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

;; Enable Evil
(require 'evil)
(evil-mode 1)
;; 
;; Use Ivy and Counsel for completions
(use-package ivy			
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ;;("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))
(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

(use-package swiper)

(use-package yasnippet)

(setq evil-motion-state-modes nil)
;; general keybindings package
(use-package general :ensure t
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   ;; simple command
   "s"   '(swiper :which-key "swiper")
   "S"   '(avy-goto-char :which-key "avy-goto-char")
   ;; window commands
   "w"   '(:ignore w :which-key "window")
   "wh"  '(evil-window-left :which-key "evil-window-left")
   "wl"  '(evil-window-right :which-key "evil-window-right")
   "wj"  '(evil-window-down :which-key "evil-window-down")
   "wk"  '(evil-window-up :which-key "evil-window-up")
   "wd"  '(evil-window-delete :which-key "evil-window-delete")
   "wv"  '(evil-window-vsplit :which-key "evil-window-vsplit")
   "ws"  '(evil-window-split  :which-key "evil-window-split")
   "b"   '(:ignore b :which-key "buffers")
   "bb"  '(counsel-switch-buffer :which-key "counsel-switch-buffer")
   "be"  '(eval-buffer :which-key "eval-buffer")
   "bd"  '(evil-delete-buffer :which-key "evil-delete-buffer")
   "bp"  '(previous-buffer :which-key "previous-buffer")
   "bn"  '(next-buffer :which-key "next-buffer")
   "f"   '(:ignore f :which-key "files")
   "ff"  '(counsel-find-file :which-key "counsel-find-file")
   ;;"'"   '(my-run-term :which-key "vterm")
   "p"   '(projectile-command-map :which-key "projectile")
   "c"   '(comment-region :which-key "comment-region")
   "t"   '(vterm :which-key "terminal")
   "n"   '(treemacs :which-key "treemacs")))
  
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))


(use-package avy :ensure t
  :commands (avy-goto-word-1)
  :bind ("M-s" . avy-goto-char))

;; terminal emulator
(use-package vterm
  :ensure t)

(use-package multi-term
  :ensure t)

(use-package term
  :config
  (setq explicit-shell-file-name "bash")
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(defun my-run-term ()
  ;"Run `evil-window-split`, `evil-window-down`, and `term` in sequence"
  (interactive)
  (evil-window-split)
  (evil-window-down)
  (vterm))

;; haskell
(use-package haskell-mode
  :ensure t)



;; better emacs help
(use-package helpful
  :ensure t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; NOTE; The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts

(use-package all-the-icons)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-height 15))


(use-package doom-themes)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))


  


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e6f3a4a582ffb5de0471c9b640a5f0212ccf258a987ba421ae2659f1eaa39b09" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "0a41da554c41c9169bdaba5745468608706c9046231bbbc0d155af1a12f32271" "4bca89c1004e24981c840d3a32755bf859a6910c65b829d9441814000cf6c3d0" "8f5a7a9a3c510ef9cbb88e600c0b4c53cdcdb502cfe3eb50040b7e13c6f4e78e" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "cae81b048b8bccb7308cdcb4a91e085b3c959401e74a0f125e7c5b173b916bf9" "d6603a129c32b716b3d3541fc0b6bfe83d0e07f1954ee64517aa62c9405a3441" "7b3d184d2955990e4df1162aeff6bfb4e1c3e822368f0359e15e2974235d9fa8" "b5fff23b86b3fd2dd2cc86aa3b27ee91513adaefeaa75adc8af35a45ffb6c499" "c086fe46209696a2d01752c0216ed72fd6faeabaaaa40db9fc1518abebaf700d" "2c49d6ac8c0bf19648c9d2eabec9b246d46cb94d83713eaae4f26b49a8183fc4" "e6ff132edb1bfa0645e2ba032c44ce94a3bd3c15e3929cdf6c049802cf059a2a" "aaa4c36ce00e572784d424554dcc9641c82d1155370770e231e10c649b59a074" "79278310dd6cacf2d2f491063c4ab8b129fee2a498e4c25912ddaa6c3c5b621e" "c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19" "3c2f28c6ba2ad7373ea4c43f28fcf2eed14818ec9f0659b1c97d4e89c99e091e" "c4bdbbd52c8e07112d1bfd00fee22bf0f25e727e95623ecb20c4fa098b74c1bd" default))
 '(js-indent-level 2)
 '(package-selected-packages
   '(elpy lsp-haskell lsp-ui lsp-mode web-mode hoon-mode evil-collection treemacs-evil treemacs js2-mode emmet-mode yasnippet-snippets yasnippet company evil-magit magit multi-term vterm projectile which-key rainbow-delimiters doom-modeline doom-themes counsel ivy use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'doom-oceanic-next)

(use-package org)

;; (defun rr-js2-tests-filter-warnings ()
;;   (setq js2-parsed-warnings
;;         (let (rslt)
;;           (dolist (e js2-parsed-warnings (reverse rslt))
;;             (when (not (string= (caar e) "msg.no.side.effects"))
;;               (setq rslt (cons (caar e) rslt))
;;               ))
;;           ))
;;   )

;; (add-hook 'js2-mode-hook
;;           (lambda ()
;;           (when (or
;;                  (string-match-p "/tests?/.*\\.js$" (buffer-file-name))
;;                  (string-match-p "\\.spec\\.js$" (buffer-file-name))
;;                  ))
;;           (add-hook 'js2-post-parse-callbacks 'rr-js2-tests-filter-warnings)
;;           )
;; )
