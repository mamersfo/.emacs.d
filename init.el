(require 'package)

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(defvar my-packages '(starter-kit
		      starter-kit-lisp
		      starter-kit-bindings
		      clojure-mode
		      clojure-test-mode
		      cider
                      markdown-mode))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(setq auto-mode-alist
      (append '(("\\.edn" . clojure-mode)
                ("\\.cljs" . clojure-mode)
                ("\\.md" . markdown-mode))
              auto-mode-alist))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(custom-safe-themes (quote ("1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "a4a1dbb04b1e08186a39375df6fa561460239ec3c7821f88ada573b66a80ede7" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(safe-local-variable-values (quote ((time-stamp-active . t) (whitespace-line-column . 80) (lexical-binding . t)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(buffer-menu-buffer ((t (:weight bold :height 140))))
 '(minibuffer-prompt ((t (:foreground "#b4fa70" :height 140))))
 '(mode-line ((t (:background "#d3d7cf" :foreground "#2e3436" :box (:line-width -1 :style released-button) :height 140)))))

;; hooks
(set-default-font "monaco 14")

;; (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(setq nrepl-hide-special-buffers t)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
;; (add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)
(setq cider-popup-stacktraces nil)

(require 'ac-nrepl)
(add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)
(add-hook 'cider-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'nrepl-mode))

(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'ac-dictionary-directories "~/emacs.d/ac-dict")
(require 'auto-complete-config)
(ac-config-default)

(add-hook 'clojure-mode-hook 'paredit-mode)

(global-set-key (kbd "M-[ 5 c") 'paredit-forward-slurp-sexp)
(global-set-key (kbd "M-[ 5 d") 'paredit-backward-slurp-sexp)

;; ESS

(require 'ess-site)

(setq auto-mode-alist
      (append '(("\\.R" . R-mode)
                ("\\.r" . R-mode))
              auto-mode-alist))

;; org-mode

(setq org-directory "~/Org")
(setq org-mobile-inbox-for-pull "~/Org/flagged.org")
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
(setq org-icalendar-combined-agenda-file "/Volumes/martin/org.ics")
(setq org-agenda-files (list "~/Org"))
(setq org-agenda-default-appointment-duration 60)
(global-set-key "\C-ca" 'org-agenda)
(require 'ox-mediawiki)

;; active Babel languages

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (sh . t)
   (emacs-lisp . t)))

;; kibit

;; Teach compile the syntax of the kibit output
(require 'compile)
(add-to-list 'compilation-error-regexp-alist-alist
             '(kibit "At \\([^:]+\\):\\([[:digit:]]+\\):" 1 2 nil 0))
(add-to-list 'compilation-error-regexp-alist 'kibit)

;; A convenient command to run "lein kibit" in the project to which
;; the current emacs buffer belongs to.
(defun kibit ()
  "Run kibit on the current project.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile "lein kibit"))

(defun kibit-current-file ()
  "Run kibit on the current file.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile (concat "lein kibit " buffer-file-name)))

;; JavaScript

(setq js-indent-level 2)

(require 'flycheck)
(add-hook 'js-mode-hook
          (lambda (0 (flycheck-mode t))))
