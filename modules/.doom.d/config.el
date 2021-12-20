;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(load! "keys.el")
(load! "org.el")
(load! "email.el")
;; (load! "irc.el")


;; --- GENERAL SETTINGS ---
(setq user-full-name "Arne Bertrand"
      user-mail-address "arnebertrand@gmail.com"
      auth-sources '("~/.authinfo.gpg"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq! truncate-lines nil)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;;(setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light  )
;;      doom-variable-pitch-font (font-spec :family "sans" :size 13))
;;
(setq doom-font (font-spec :family "Hasklig" :size 30 :weight 'semi-light))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one
      doom-themes-treemacs-theme "doom-colors")

;; make pl files trigger prolog-mode
(setq auto-mode-alist
      (cons (cons "\\.pl" 'prolog-mode) auto-mode-alist))

;; ---MODULE SPECIFIC---

(setq! plantuml-jar-path "/usr/share/java/plantuml/plantuml.jar")


(after! rustic
  (setq rustic-lsp-server 'rust-analyzer)
  )

(after! treemacs
  (treemacs-define-RET-action 'file-node-open #'treemacs-visit-node-in-most-recently-used-window)
  (treemacs-define-RET-action 'file-node-closed #'treemacs-visit-node-in-most-recently-used-window)
  (treemacs-define-RET-action 'tag-node #'treemacs-visit-node-in-most-recently-used-window)
  )

(add-hook! (js-mode web-mode)
  (ember-mode)
  )

;; prefer the format module for formatting
(setq +format-with-lsp nil)
(set-formatter!
  'prettier-glimmer
  "prettier --parser glimmer"
  :modes
  '((web-mode (if (member (file-name-extension (buffer-file-name)) '("hbs")) t)))
  )

;; disable ij in insert mode throwing you in normal mode
(after! evil
  (setq! evil-escape-key-sequence nil)
  )

;; --- UTILITIES ---

;; Autosave on focus loss
(defun save-all ()
  (interactive)
  (save-some-buffers t))
(add-hook! 'focus-out-hook 'save-all)

;; Utility to convert markdown to org
(defun markdown-convert-to-org ()
  "Convert the current selection from markdown to orgmode format in-place."
  (interactive)
  (shell-command-on-region (point-min) (point-max)
                           (format "pandoc -f markdown -t org -o '<,'>s")))

;; Here ar
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
