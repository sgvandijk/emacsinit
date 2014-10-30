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
 '(elpy-modules (quote (elpy-module-company elpy-module-eldoc elpy-module-pyvenv elpy-module-highlight-indentation elpy-module-yasnippet elpy-module-sane-defaults)))
 '(flycheck-clang-include-path (quote ("/usr/include/i386-linux-gnu/c++/4.8/" "/usr/include/eigen3" "/home/sander/bold-humanoid/rapidjson/include" "/usr/include/sigc++-2.0/" "/usr/lib/i386-linux-gnu/sigc++-2.0/include/" "/home/sander/bold-humanoid/libwebsockets/lib/" "/home/sander/bold-humanoid/test/google-test/include/")))
 '(flycheck-clang-language-standard "c++11")
 '(flycheck-clang-warnings (quote ("no-deprecated")))
 '(flycheck-cppcheck-checks (quote ("style")))
 '(flycheck-idle-change-delay 0.1)
 '(indent-tabs-mode nil)
 '(irony-additional-clang-options (quote ("-std=c++11" "-I/usr/include/i386-linux-gnu/c++/4.8/")))
 '(js-indent-level 4)
 '(safe-local-variable-values (quote ((TeX-engine . pdftex) (TeX-master . t) (TeX-engine . luatex))))
 '(tool-bar-mode nil)
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

;;; Company mode everywhere
(add-hook 'after-init-hook 'global-company-mode)

;;; Uniqiufy buffer names
(require 'uniquify)

;;; PHP mode
(require 'php-mode)

;;; .ih files are c++ files
(add-to-list 'auto-mode-alist '("[.]ih$" . c++-mode))

;;; .ts ar JS files
(add-to-list 'auto-mode-alist '("[.]ts$" . js-mode))

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

(eval-after-load "yasnippet"
  '(progn
     (yas-reload-all t)
     ))

(add-hook 'after-init-hook #'global-flycheck-mode)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)

(setq irony-additional-clang-options (quote ("-std=c++11" "-I/usr/include/i386-linux-gnu/c++/4.8")))

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

;; (optional) adds CC special commands to `company-begin-commands' in order to
;; trigger completion at interesting places, such as after scope operator
;;     std::|
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

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
;(set-face-background 'mode-line-inactive "#2e3436")
;(set-face-background 'mode-line "#fce94f")

;; Bind magit
(global-set-key (kbd "C-x g") 'magit-status)


;; Python mode
(elpy-enable)
