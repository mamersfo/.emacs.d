;;; init.el --- user init file -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'package)

(add-to-list
 'package-archives
 '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(package-initialize)

(defvar my-packages '(clojure-mode cider company paredit paredit-everywhere smex ess))
  
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(setq auto-mode-alist
      (append '(("\\.edn"  .  clojure-mode)
                ("\\.cljs" .  clojurescript-mode)
                ("\\.cljc" .  clojure-mode)
                ("\\.json" .  json-mode)
                ("\\.js"   .  js-mode)
                ("\\.tsx"  .  typescript-mode)
                ("\\.Rmd"  .  markdown-mode)
                ("\\.rs"   .  rust-mode))
              auto-mode-alist))

;; company (completion) -- require first so `company-idle-delay' and
;; `company-indent-or-complete-common' are known to the byte-compiler.
(require 'company nil t)
(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)

(setq company-idle-delay nil) ; never start completions automatically
(with-eval-after-load 'company
  (global-set-key (kbd "TAB") #'company-indent-or-complete-common))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(clojure-indent-style :always-indent)
 '(custom-enabled-themes '(dracula))
 '(custom-safe-themes
   '("19ec0fddf995b9b73c6a5ff0ad6474890a24018a1db845678ac632e2d54d891f"
     "fe1c13d75398b1c8fd7fdd1241a55c286b86c3e4ce513c4292d01383de152cb7"
     "addfaf4c6f76ef957189d86b1515e9cf9fcd603ab6da795b82b79830eed0b284"
     "e7aa1c216e14ec250a367908e305dc7f2d549a4b3f87f4a0515ef5d3800fc2f5"
     default))
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(js2-strict-missing-semi-warning nil)
 '(package-selected-packages
   '(anakondo cargo cider cider-eval-sexp-fu company csharp-mode
              csv-mode cyberpunk-theme docker-compose-mode
              dockerfile-mode dracula-theme ess flycheck-clj-kondo
              flycheck-clojure flycheck-rust graphviz-dot-mode
              json-mode magit markdown-mode nhexl-mode
              paredit-everywhere projectile rust-mode s smex
              typescript-mode web-mode yasnippet))
 '(safe-local-variable-values
   '((time-stamp-active . t) (whitespace-line-column . 80)
     (lexical-binding . t)))
 '(tab-width 2))

;; fonts
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(buffer-menu-buffer ((t (:weight bold :height 140))))
 '(minibuffer-prompt ((t (:foreground "#b4fa70" :height 140))))
 '(mode-line ((t (:background "#d3d7cf" :foreground "#2e3436" :box (:line-width -1 :style released-button) :height 140)))))

;; (set-default-font "monaco 14")

;; paredit
(require 'paredit nil t)
(require 'paredit-everywhere nil t)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook    'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'rjsx-mode-hook       'paredit-everywhere-mode)

(show-paren-mode 1)

(global-set-key (kbd "M-[ 5 c") 'paredit-forward-slurp-sexp)
(global-set-key (kbd "M-[ 5 d") 'paredit-backward-slurp-sexp)

;; cider
;; `nrepl-hide-special-buffers' is defined in nrepl-client,
;; `cider-show-error-buffer' in cider-eval (modern replacement for the
;; long-removed `cider-popup-stacktraces').  Use `with-eval-after-load'
;; plus forward declarations so we don't eagerly load cider (which
;; would trigger upstream "cl-old-struct-compat-mode is obsolete"
;; warnings from clojure-mode/cider on Emacs 31) and the byte-compiler
;; stays quiet.
(defvar nrepl-hide-special-buffers)
(defvar cider-show-error-buffer)
(with-eval-after-load 'nrepl-client
  (setq nrepl-hide-special-buffers t))
(with-eval-after-load 'cider-eval
  (setq cider-show-error-buffer nil)) ; don't popup stacktraces

;; ESS
;; NOTE: don't `(require 'ess-site)' here -- it pulls in the obsolete
;; `ess-jags-d' package ("Package ess-jags-d is deprecated" warning) and
;; slows startup.  `(require 'ess)' is enough for R-mode, and ELPA
;; autoloads already set up auto-mode-alist entries.
(require 'ess nil t)
(setq auto-mode-alist
      (append '(("\\.R" . R-mode)
                ("\\.r" . R-mode))
              auto-mode-alist))

;; org-mode
(require 'org)
(require 'org-agenda)
(require 'ox-icalendar)
(require 'org-mobile)
(setq org-directory "~/Org")
(setq org-mobile-inbox-for-pull "~/Org/flagged.org")
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
(setq org-icalendar-combined-agenda-file "/Volumes/martin/org.ics")
(setq org-agenda-files (list "~/Org"))
(setq org-agenda-default-appointment-duration 60)
(global-set-key "\C-ca" 'org-agenda)

;; smex
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

;; backup files
(setq
 backup-by-copying t
 backup-directory-alist '(("." . "~/.saves"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

(require 'dired-x)
(setq-default dired-omit-files-p t)
(setq dired-omit-files
      (concat dired-omit-files "\\|\\.DS_Store$"))

;;; init.el ends here
