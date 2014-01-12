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
 '(indent-tabs-mode nil)
 '(safe-local-variable-values (quote ((TeX-engine . pdftex) (TeX-master . t) (TeX-engine . luatex))))
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "Grey15" :foreground "Grey" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 83 :width normal :foundry "unknown" :family "Liberation Mono")))))

;;; Use MELPA repository
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

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
(tool-bar-mode -1)

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


;;; Hooks run when going into c-mode
(add-hook 'c-mode-common-hook
	  (lambda ()
	    (modify-syntax-entry ?_ "w") ; Underscores are part of words
	    ; Code hiding/folding
            (hs-minor-mode)
            (global-set-key [?\C-x kp-add] 'hs-toggle-hiding)
            (global-set-key [?\C-x C-kp-add] 'hs-show-all)
            (global-set-key [?\C-x C-kp-subtract] 'hs-hide-all)
	    ))

(add-hook 'c++-mode-hook
          (lambda ()
            (yas-minor-mode)
            ))

(eval-after-load "yasnippet"
  '(progn
     (yas-reload-all t)
     ))

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
