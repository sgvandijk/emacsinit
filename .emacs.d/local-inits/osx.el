(require `cl)

(setenv "PATH" (concat (getenv "PATH") ":" "/Library/TeX/texbin"))
(add-to-list 'exec-path "/Library/TeX/texbin")

(setenv "PATH" (concat (getenv "PATH") ":" "/usr/local/bin"))
(add-to-list 'exec-path "/usr/local/bin")
