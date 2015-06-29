(require `cl)

(setenv "PATH" (concat "/usr/texbin" ":" (getenv "PATH")))

(setq exec-path (append exec-path '("/usr/local/bin")))
