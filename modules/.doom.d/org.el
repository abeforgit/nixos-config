;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;;
(defvar agenda-block--today-schedule
  '(agenda "" ((org-agenda-overriding-header "Today's Schedule:")
	       (org-agenda-span 'day)
	       (org-agenda-ndays 1)
	       (org-agenda-start-on-weekday nil)
	       (org-agenda-start-day "+0d")))
  "A block showing a 1 day schedule.")
(defvar agenda-block--alltodos
  '(alltodo)
  "A block showing all todo items.")

(defvar agenda-block--unscheduled
  '(todo "" (
             (org-agenda-overriding-header "Unscheduled TODOs")
             (org-agenda-todo-ignore-scheduled 'all)
             (org-agenda-todo-ignore-deadlines 'all)
             ))
  "A block showing all todo items.")
(setq! org-directory "~/org/"
       org-roam-graph-viewer "firefox-developer-edition"
       org-roam-dailies-directory "dailies/"
       deft-directory "~/org"
       deft-recursive t)

(after! org
  (setq! org-capture-templates
         '(
           ("t" "Todo")
           ("tt" "Todo" entry (file+headline "~/org/todo.org" "Inbox")
            "* TODO %?\n  %i\n   %a"
            )
           ("tp" "PR" entry (file+headline "~/org/todo.org" "Inbox")
            "* TODO %? :review:\n  %i\n   %a"
            )
           ("m" "Meeting" entry (file+headline "~/org/todo.org" "Work")
            "* MEETING %?\n  %i\n   %a"
            )
           )
         org-todo-keywords
         '((sequence "TODO(t)" "MEETING(m)" "STRT(s)" "WAIT(w)" "|" "DONE(d)" "KILL(k)")
           )
         org-refile-targets
         '((nil :maxlevel . 3)
           (org-agenda-files :maxlevel . 3))
         org-time-clocksum-use-fractional t
         org-agenda-custom-commands `(
                                      ("d" "Daily schedule"
                                       (,agenda-block--today-schedule
                                        ,agenda-block--unscheduled)
                                       )
                                      )
         calendar-week-start-day 1
         org-table-convert-region-max-lines 10000
         )

  )

(after! org-roam
  (setq! org-roam-dailies-capture-templates '(("d" "daily" plain (function org-roam-capture--get-point) ""
                                               :immediate-finish t
                                               :file-name "dailies/%<%Y-%m-%d>"
                                               :head "#+TITLE: %<%Y-%m-%d>")))
  )

