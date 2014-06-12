;; -*-Emacs-Lisp-*-

(setq load-path (cons "~/.emacs.d" load-path))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-clang-cflags (quote ("-I/usr/local/include/pcl-1.7" "-I/usr/include/eigen3")))
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (tango-dark)))
 '(flycheck-clang-include-path (quote ("/usr/include/i386-linux-gnu/c++/4.8/" "/usr/include/eigen3" "/home/sander/bold-humanoid/rapidjson/include" "/usr/include/sigc++-2.0/" "/usr/lib/i386-linux-gnu/sigc++-2.0/include/")))
 '(flycheck-clang-language-standard "c++11")
 '(flycheck-clang-warnings (quote ("no-deprecated")))
 '(flycheck-cppcheck-checks (quote ("style")))
 '(indent-tabs-mode nil)
 '(js-indent-level 4)
 '(safe-local-variable-values (quote ((TeX-engine . pdftex) (TeX-master . t) (TeX-engine . luatex))))
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))

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

;;; Turn off system bell
(setq visible-bell t)

;;; Tabbing and indenting
(setq c-default-style "bsd"
      c-basic-offset 2)

;;; Don't show startup message
(setq inhibit-startup-message t)

;;; Interactive do
(require 'ido)
(ido-mode t)

;;; Uniqiufy buffer names
(require 'uniquify)

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

;;; Follow compilation output
;(setq compilation-scroll-output t)

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

(autoload 'tex-mode "auctex")

(autoload 'LaTeX-preview-setup "preview")
(add-hook 'LaTeX-mode-hook #'LaTeX-preview-setup)

(add-hook 'LaTeX-mode-hook 
	  (lambda ()
	    (setq TeX-auto-save t)
	    (setq TeX-parse-self t)
            (setq TeX-engine-alist '((luatex "LuaTeX" "luatex" "lualatex --shell-escape --jobname=%s" "luatex")))
	    (flyspell-mode)
	    (LaTeX-math-mode)
	    (outline-minor-mode)
	    (turn-on-reftex)
	    (setq reftex-plug-into-AUCTeX t)
	    (TeX-PDF-mode t)
	    )
	  )


;;; Automatically reload bibtex files
(add-hook 'bibtex-mode-hook
	  'turn-on-auto-revert-mode)

;; (setq semantic-default-submodes (append semantic-default-submodes
;;                                         '(global-semantic-idle-local-symbol-highlight-mode
;;                                           global-semantic-idle-completions-mode
;;                                           global-semantic-idle-summary-mode
;;                                           global-semantic-decoration-mode
;;                                           global-semantic-highlight-func-mode
;;                                           global-semantic-stickyfunc-mode
;;                                           global-semantic-show-unmatched-syntax-mode
;;                                           global-semantic-mru-bookmark-mode)))
;; (semantic-mode 1)

(ac-config-default)
(eval-after-load "yasnippet"
  '(progn
     (yas-reload-all t)
     ))
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/irony-mode/elisp/"))
;(require 'irony)
;(irony-enable 'ac)

;;; Hooks run when going into c-mode
(defun my-c-mode-hook ()
  (modify-syntax-entry ?_ "w") ; Underscores are part of words

  (yas-minor-mode)

  (hs-minor-mode) ; Code hiding/folding
  (define-key global-map (kbd "C-c +") 'hs-toggle-hiding)
  (define-key global-map (kbd "C-c C-+") 'hs-show-all)
  (define-key global-map (kbd "C-c C--") 'hs-hide-all)

  (define-key global-map (kbd "C-c ;") 'iedit-mode)
  (irony-mode 1)
)

(add-hook 'c-mode-common-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

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
(set-face-background 'mode-line "#fce94f")

;; Bind magit
(global-set-key (kbd "C-x g") 'magit-status)
