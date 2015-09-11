;; -*-Emacs-Lisp-*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 2)
 '(c-default-style
   (quote
    ((java-mode . "java")
     (c++-mode . "bsd")
     (awk-mode . "awk")
     (other . "gnu"))))
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (tango-dark)))
 '(elpy-modules
   (quote
    (elpy-module-company
     elpy-module-eldoc
     elpy-module-pyvenv
     elpy-module-highlight-indentation
     elpy-module-yasnippet
     elpy-module-sane-defaults)))
 '(elpy-rpc-backend "rope")
 '(flycheck-clang-include-path
   (quote
    ("/usr/include/i386-linux-gnu/c++/4.8/" "/usr/include/eigen3/")))
 '(flycheck-clang-language-standard "c++11")
 '(indent-tabs-mode nil)
 '(irony-additional-clang-options
   (quote
    ("-I/usr/include/i386-linux-gnu/c++/4.8" "-std=c++11")))
 '(ispell-program-name "aspell")
 '(js-indent-level 2)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))

(setq magit-last-seen-setup-instructions "1.4.0")

;; Load local configuration file
(load "~/.emacs.d/local.el")

;; Package Manager
;; See ~Cask~ file for its configuration
;; https://github.com/cask/cask
(require 'cask "~/.cask/cask.el")
(cask-initialize)

;; Keeps ~Cask~ file in sync with the packages
;; that you install/uninstall via ~M-x list-packages~
;; https://github.com/rdallasgray/pallet
(require 'pallet)
(pallet-mode t)

;;; Turn off system bell
(setq visible-bell t)

;;; Don't show startup message
(setq inhibit-startup-message t)

;;; Interactive do
(require 'ido)
(ido-mode t)

;;; Company mode everywhere
(add-hook 'after-init-hook 'global-company-mode)

;;; Uniqiufy buffer names
(require 'uniquify)


;;; multiple cursors bindings
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;;; PHP mode
;(require 'php-mode)

;;; .ih files are c++ files
(add-to-list 'auto-mode-alist '("[.]ih$" . c++-mode))

;;; Function to rerun last compile command in appropriate buffer
(global-set-key (kbd "C-x <f9>") 'compile-again)

(setq compilation-last-buffer nil)
(defun compile-again (pfx)
  """Run the same compile as the last time.

If there was no last time, or there is a prefix argument, this acts like
M-x compile.
"""
(interactive "p")
(if (and (eq pfx 1)
         compilation-last-buffer)
    (progn
      (set-buffer compilation-last-buffer)
      (revert-buffer t t))
  (call-interactively 'compile)))

;;; Run debugger
(global-set-key (kbd "C-x <f10>") 'gdb)


;;; Line numbering
(linum-mode)
;;; Number *every* line!
(global-linum-mode 1)

;;; No tool bar
 (if window-system
     (tool-bar-mode -1))

;;; Load latex stuff
(setq-default TeX-master nil)

;; (autoload 'LaTeX-preview-setup "preview")
;; (add-hook 'LaTeX-mode-hook #'LaTeX-preview-setup)

(add-hook 'LaTeX-mode-hook 
	  (lambda ()
	    (setq TeX-auto-save t)
	    (setq TeX-parse-self t)
            ;; (setq TeX-engine-alist '((luatex "LuaTeX" "luatex" "lualatex --shell-escape --jobname=%s" "luatex")))
	    (flyspell-mode)
	    (LaTeX-math-mode)
	    (outline-minor-mode)
	    (turn-on-reftex)
	    (setq reftex-plug-into-AUCTeX t)
	    (TeX-PDF-mode t)
            (company-auctex-init)
	    )
	  )


;; ;;; Automatically reload bibtex files
;; (add-hook 'bibtex-mode-hook
;; 	  'turn-on-auto-revert-mode)

(eval-after-load "yasnippet"
  '(progn
     (yas-reload-all t)
     ))

(add-hook 'after-init-hook #'global-flycheck-mode)

;;; Hooks run when going into c-mode
(defun my-c-mode-hook ()
  (modify-syntax-entry ?_ "w") ; Underscores are part of words

  (yas-minor-mode)

  (hs-minor-mode) ; Code hiding/folding
  (define-key global-map (kbd "C-c +") 'hs-toggle-hiding)
  (define-key global-map (kbd "C-c C-+") 'hs-show-all)
  (define-key global-map (kbd "C-c C--") 'hs-hide-all)

  (define-key global-map (kbd "C-c ; a") 'mc/mark-all-like-this)
  (define-key global-map (kbd "C-c ; l") 'mc/edit-beginnings-of-lines)
  (when (member major-mode irony-supported-major-modes)
    (irony-mode 1))
  )

(add-hook 'c++-mode-hook 'my-c-mode-hook)
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'objc-mode-hook 'my-c-mode-hook)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async)
  (irony-eldoc))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)


(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))


(require 'flycheck-irony)
(eval-after-load 'flycheck
  '(add-to-list 'flycheck-checkers 'irony))

;; (optional) adds CC special commands to `company-begin-commands' in order to
;; trigger completion at interesting places, such as after scope operator
;;     std::|
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

;;; Haskell mode
(autoload 'haskell-mode "haskell-mode")
(autoload 'literate-haskell-mode "haskell-mode")
;; Set indentation

(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)

;; gh, hs and hi files are Haskell
(add-to-list 'auto-mode-alist        '("\\.\\(?:[gh]s\\|hi\\)\\'" . haskell-mode))
;; lgh and lhs files are literate haskell
(add-to-list 'auto-mode-alist        '("\\.l[gh]s\\'" . literate-haskell-mode))

;; Stuff to run ghc/haskell as inferior process
(add-to-list 'interpreter-mode-alist '("runghc" . haskell-mode))
(add-to-list 'interpreter-mode-alist '("runhaskell" . haskell-mode))

(defalias 'run-haskell 'switch-to-haskell)

(autoload 'switch-to-haskell "inf-haskell")
(autoload 'inferior-haskell-load-file "inf-haskell")
(autoload 'inferior-haskell-load-and-run "inf-haskell")
(autoload 'inferior-haskell-type "inf-haskell")
(autoload 'inferior-haskell-info "inf-haskell")
(autoload 'inferior-haskell-find-definition "inf-haskell")
(autoload 'inferior-haskell-find-haddock "inf-haskell")

;; ghc-mod
(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))


;; cmake mode
(autoload 'cmake-mode "cmake-mode")
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
		("\\.cmake\\'" . cmake-mode))
	      auto-mode-alist))

;; julia mode
(autoload 'julia-mode "julia-mode")
(add-to-list 'auto-mode-alist '("\\.jl\\'" . julia-mode))

;; Extra bright mode line
(set-face-background 'mode-line-inactive "#2e3436")
(set-face-background 'mode-line "#fcaf3e")

;; Bind magit
(global-set-key (kbd "C-x g") 'magit-status)

;; Python mode
(eval-after-load 'elpy
  '(progn
     (load "flymake")
     (define-key elpy-mode-map (kbd "C-<left>") nil)
     (define-key elpy-mode-map (kbd "C-<right>") nil)
     (define-key elpy-mode-map (kbd "C-<up>") nil)
     (define-key elpy-mode-map (kbd "C-<down>") nil)
     )
  )

(add-hook 'markdown-mode-hook
          (lambda ()
            (flyspell-mode)
            ))

;;; init.el ends here
