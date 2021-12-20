;;; lang/ember/config.el -*- lexical-binding: t; -*-

(use-package! ember-mode
  :commands (ember-mode)
  :config
  (message "setting keymap")
  (map! :map ember-mode-keymap
        :localleader
        (:prefix ("." . "ember")
         (:prefix ("f" . "find")
          "c" #'ember-open-controller
          "m" #'ember-open-model
          "o" #'ember-open-router
          "p" #'ember-open-component
          "r" #'ember-open-route
          "j" #'ember-open-javascript
          "t" #'ember-open-template
          "v" #'ember-open-view
          "x" #'ember-open-mixin
          "i" #'ember-open-initializer
          "u" #'ember-open-util
          "s" #'ember-open-service
          "a" #'ember-toggle-addon
          )
         (:prefix ("g" . "generate")
          "c" #'ember-generate-controller
          "m" #'ember-generate-model
          "o" #'ember-generate-router
          "p" #'ember-generate-component
          "r" #'ember-generate-route
          "t" #'ember-generate-template
          "v" #'ember-generate-view
          "x" #'ember-generate-mixin
          "i" #'ember-generate-initializer
          "u" #'ember-generate-util
          "s" #'ember-generate-service
          "g" #'ember-generate
          )
         (:prefix ("d" . "destroy")
          "c" #'ember-destroy-controller
          "m" #'ember-destroy-model
          "o" #'ember-destroy-router
          "p" #'ember-destroy-component
          "r" #'ember-destroy-route
          "t" #'ember-destroy-template
          "v" #'ember-destroy-view
          "x" #'ember-destroy-mixin
          "i" #'ember-destroy-initializer
          "u" #'ember-destroy-util
          "s" #'ember-destroy-service
          "g" #'ember-destroy
          )

         (:prefix ("r" . "run")
          "b" #'ember-build
          "s" #'ember-serve-or-display
          "t" #'ember-test
          )
         (:prefix ("i" . "import")
          "u" #'ember-import-upgrade-import-statement-at-point
          "e" #'ember-import-from-ember-at-point
          "d" #'ember-import-decorator-at-point
          )
         )
        )
  (message "finished setting keymap")
  )
(if (featurep! +lsp)
    (progn
      (add-hook! '(
                  js2-mode-local-vars-hook
                  web-mode-local-vars-hook
                  typescript-mode-local-vars-hook
                  )
       (defun ember-lsp-init () (lsp!))
       )
     (after! lsp-mode
       (lsp-register-client
        (make-lsp-client :new-connection (lsp-stdio-connection (list "node" "/home/arne/repos/installations/ember-language-server/lib/start-server.js" "--stdio"))
                         :major-modes '(js2-mode web-mode typescript-mode)
                         :priority -1
                         :ignore-messages (list "Initializing Ember Language Server at .*$")
                         :add-on? t
                         :server-id 'ember-ls))
       )
     )
  )
