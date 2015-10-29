(require `cl)

(setenv "PATH" (concat "/Library/TeX/texbin" ":" (getenv "PATH")))
(setenv "PATH" (concat "/usr/local/bin" ":" (getenv "PATH")))
(add-to-list 'exec-path "/usr/local/bin")
