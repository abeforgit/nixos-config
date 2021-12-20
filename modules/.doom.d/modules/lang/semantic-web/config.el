;;; lang/semantic-web/config.el -*- lexical-binding: t; -*-

(setq auto-mode-alist
      (cons (cons "\\.\\(ttl\\|n3\\)" 'ttl-mode) auto-mode-alist))

(setq auto-mode-alist
      (cons (cons "\\.\\(sparql\\|rq\\)" 'ttl-mode) auto-mode-alist))

(use-package! ttl-mode
  :commands (ttl-mode)
  )

(use-package! sparql-mode
  :commands (sparql-mode)
  :config
  (map! :map sparql-mode-map
        :localleader
        "q" #'sparql-query-region
        )
  )
;; (after! sparql-mode
;;   (set-company-backend! 'sparql-mode)
;;   )
