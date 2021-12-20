(set-email-account! "gmail"
                    '((mu4e-sent-folder       . "/gmail/[Gmail].Sent Mail")
                      (mu4e-drafts-folder     . "/drafts")
                      (mu4e-trash-folder      . "/gmail/[Gmail].Bin")
                      (mu4e-refile-folder     . "/gmail/[Gmail].Store")
                      (smtpmail-smtp-user     . "arnebertrand@gmail.com")
                      (smtpmail-local-domain  . "gmail.com")
                      (smtpmail-default-smtp-server . "smtp.gmail.com")
                      (smtpmail-smtp-server . "smtp.gmail.com")
                      (smtpmail-smtp-service . 587))
                    t
                    )
(set-email-account! "redpencil"
                    '((mu4e-sent-folder       . "/redpencil/[Gmail].Sent Mail")
                      (mu4e-drafts-folder     . "/drafts")
                      (mu4e-trash-folder      . "/redpencil/[Gmail].Trash")
                      (mu4e-refile-folder     . "/redpencil/[Gmail].All Mail")
                      (smtpmail-smtp-user     . "arne.bertrand@redpencil.io")
                      (smtpmail-local-domain  . "gmail.com")
                      (smtpmail-default-smtp-server . "smtp.gmail.com")
                      (smtpmail-smtp-server . "smtp.gmail.com")
                      (smtpmail-smtp-service . 587))
                    nil
                    )
(add-hook 'mu4e-compose-pre-hook
          (defun my-set-from-address ()
            "Set the From address based on the To address of the original."
            (let ((msg mu4e-compose-parent-message)) ;; msg is shorter...
              (when msg
     	        (setq user-mail-address
     	              (cond
     	               ((mu4e-message-contact-field-matches msg :to "arnebertrand@gmail.com")
     	                "arnebertrand@gmail.com")
     	               ((mu4e-message-contact-field-matches msg :to "arne.bertrand@redpencil.io")
     	                "arne.bertrand@redpencil.io")
     	               (t "")))))))
(setq! mu4e-bookmarks
       '(( :name  "Unread messages"
           :query "flag:unread AND NOT flag:trashed"
           :key ?u)
         ( :name "Today's messages"
           :query "date:today..now"
           :key ?t)
         ( :name "Last 7 days"
           :query "date:7d..now"
           :hide-unread t
           :key ?l)
         ;; ( :name "Messages with images"
         ;;   :query "mime:image/*"
         ;;   :key ?p)
         (:name "Combined Inbox"
          :query "maildir:/gmail/INBOX OR maildir:/redpencil/INBOX"
          :key ?i)
         (:name "Personal Inbox"
          :query "maildir:/gmail/INBOX"
          :key ?p)
         (:name "Work Inbox"
          :query "maildir:/redpencil/INBOX"
          :key ?w))
       )
