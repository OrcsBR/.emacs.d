;; Core Startup

(package-initialize)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-copy-env "PYTHONPATH")
  (exec-path-from-shell-initialize))
  (add-to-list 'load-path "/usr/bin/emacsclient")
  (add-to-list 'exec-path "/usr/bin/sqlite3")
  (setq pandoc-binary "/usr/bin/pandoc")
  (setq pandoc-data-dir "~/.emacs.d/pandoc-mode/")

(when (string-equal system-type "windows-nt"))
 (add-to-list 'exec-path "/Sqlite3/")

(server-start)

(require 'org)
(require 'org-protocol)
(require 'org-capture)
(require 'org-web-tools)
(require 'helm-config)
(require 'org-id)

(use-package emms)

(require 'emms-setup)
(emms-all)
(emms-default-players)

(require 'emms-player-simple)
(require 'emms-source-file)
(require 'emms-source-playlist)
(setq emms-source-file-default-directory "/mnt/")

(setq org-modules (quote (org-protocol)))

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("org" . "https://orgmode.org/elpa/")
	("marmalade" . "http://marmalade-repo.org/packages/")
	("melpa" . "http://melpa.milkbox.net/packages/")))

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

;; Modifiers

(setq mac-command-modifier 'control)
(setq mac-control-modifier 'hyper)
(setq ns-function-modifier 'hyper)
(setq w32-lwindow-modifier 'super)
(setq w32-apps-modifier 'hyper)

;; iDo

(setq ido-create-new-buffer 'always)
(setq ido-file-extensions-order '(".org" ".txt" ".py" ".emacs" ".xml" ".el" ".ini" ".cfg" ".cnf"))
(global-set-key (kbd "C-x f") #'ido-find-file)

; Misc Global Key Setting Down Here

(global-set-key (kbd "C-w") #'kill-ring-save)
(global-set-key (kbd "M-w") #'kill-region)
(global-set-key (kbd "C-v") #'yank)
(global-set-key (kbd "M-v") #'scroll-down-command)
(global-set-key (kbd "M-V") #'scroll-up-command)
(global-set-key (kbd "C-z") #'undo)
(global-set-key (kbd "C-x l") #'set-fill-column)
(global-set-key (kbd "C-x r s") #'bookmark-set)
(global-set-key (kbd "C-.") #'next-buffer)
(global-set-key (kbd "C-,") #'previous-buffer)
;;(global-set-key (kbd "C-x <f4>") #'save-buffers-kill-terminal)
;;(global-unset-key (kbd "C-x C-c"))
		   
;; Org Shortcuts

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key (kbd "<f8>") 'org-cycle-agenda-files)

(define-key org-mode-map (kbd "C-c o") 'org-occur)

;; Org Roam and Org-Journal

(use-package org-roam
    :ensure t
    :hook
    (after-init . org-roam-mode)
    :custom
    (org-roam-directory "~/Dropbox/OrgRoam/")
    (org-roam-completion-system 'helm)
    :bind (:map org-roam-mode-map
          (("C-c r o" . org-roam)
           ("C-c r f" . org-roam-find-file)
           ("C-c r g" . org-roam-graph)
           ("C-c n r" . org-roam-db-build-cache)
           :map org-mode-map
           (("C-c r i" . org-roam-insert))
           (("C-c r I" . org-roam-insert-immediate))))
    :config
    (require 'org-roam-protocol))

(use-package org-journal
  :bind
  ("C-c f j" . org-journal-new-entry) 
  :custom
  (org-journal-date-prefix "#+title: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-dir "~/Dropbox/OrgRoam/Journal/")
  (org-journal-date-format "%A, %d %B %Y"))

(defun org-journal-find-location ()
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
  (org-journal-new-entry t)
  ;; Position point on the journal's top-level heading so that org-capture
  ;; will add the new entry as a child entry.
  (goto-char (point-min)))

;; Exclude Helm Buffers from Buffer List

(defun my-buffer-predicate (buffer)
  (if (string-match "helm" (buffer-name buffer))
      nil
    t))
(set-frame-parameter nil 'buffer-predicate 'my-buffer-predicate)

;; Hide Toolbar on new frames

(menu-bar-showhide-tool-bar-menu-customize-disable)

;; Bigger font on Mini-buffer

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup)
(defun my-minibuffer-setup ()
       (set (make-local-variable 'face-remapping-alist)
	    '((default :height 1.75))))

;; Helm

(helm-mode t)

(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x C-b") #'helm-mini)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x c b") #'list-buffers)
(global-set-key (kbd "M-X") #'execute-extended-command) ;; Keeping that close
(global-set-key (kbd "C-x r m") #'helm-filtered-bookmarks)

(setq helm-always-two-windows nil)
(setq helm-display-buffer-default-height 20)

;; (setq helm-default-display-buffer-functions '(display-buffer-in-side-window))
;; above (commented out) code breaks helm opening below current window. 

;; Yasnippet

(require 'yasnippet)
(yas-global-mode 1)

;; Ace-Window

(global-set-key (kbd "M-o") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
;; (setq aw-background nil)

;; Berndt Hansen's Functions with Shortcuts

(global-set-key (kbd "<f5>") 'bh/org-todo)

(defun bh/org-todo (arg)
  (interactive "p")
  (if (equal arg 4)
      (save-restriction
        (bh/narrow-to-org-subtree)
        (org-show-todo-tree nil))
    (bh/narrow-to-org-subtree)
    (org-show-todo-tree nil)))

(global-set-key (kbd "<S-f5>") 'bh/widen)

(defun bh/widen ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
        (org-agenda-remove-restriction-lock)
        (when org-agenda-sticky
          (org-agenda-redo)))
    (widen)))

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "W" (lambda () (interactive) (setq bh/hide-scheduled-and-waiting-next-tasks t) (bh/widen))))
          'append)

;;(global-set-key (kbd "<f9> b") 'bbdb)
;;(global-set-key (kbd "<f9> c") 'calendar)
(global-set-key (kbd "<f9> f") 'boxquote-insert-file)
;;(global-set-key (kbd "<f9> g") 'gnus)
(global-set-key (kbd "<f9> h") 'bh/hide-other)
(global-set-key (kbd "<f9> n") 'bh/toggle-next-task-display)
(global-set-key (kbd "<f9> I") 'bh/punch-in)
(global-set-key (kbd "<f9> O") 'bh/punch-out)
(global-set-key (kbd "<f9> o") 'bh/make-org-scratch)
(global-set-key (kbd "<f9> r") 'boxquote-region)
(global-set-key (kbd "<f9> s") 'bh/switch-to-scratch)
(global-set-key (kbd "<f9> t") 'bh/insert-inactive-timestamp)
(global-set-key (kbd "<f9> T") 'bh/toggle-insert-inactive-timestamp)
(global-set-key (kbd "<f9> v") 'visible-mode)
(global-set-key (kbd "<f9> l") 'org-toggle-link-display)
(global-set-key (kbd "<f9> SPC") 'bh/clock-in-last-task)
(global-set-key (kbd "<f11>") 'org-clock-goto)
(global-set-key (kbd "C-<f11>") 'org-clock-in)
(global-set-key (kbd "C-x n r") 'narrow-to-region)
(global-set-key (kbd "M-<f5>") 'org-toggle-inline-images)

(defun bh/hide-other ()
  (interactive)
  (save-excursion
    (org-back-to-heading 'invisible-ok)
    (hide-other)
    (org-cycle)
    (org-cycle)
    (org-cycle)))

(defun bh/make-org-scratch ()
  (interactive)
  (find-file "/tmp/publish/scratch.org")
  (gnus-make-directory "/tmp/publish"))

(defun bh/switch-to-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))

(defvar bh/insert-inactive-timestamp t)

(defun bh/toggle-insert-inactive-timestamp ()
  (interactive)
  (setq bh/insert-inactive-timestamp (not bh/insert-inactive-timestamp))
  (message "Heading timestamps are %s" (if bh/insert-inactive-timestamp "ON" "OFF")))

(defun bh/insert-inactive-timestamp ()
  (interactive)
  (org-insert-time-stamp nil t t nil nil nil))

;; (defun bh/insert-heading-inactive-timestamp ()
;;  (save-excursion
;;    (when bh/insert-inactive-timestamp
;;      (org-return)
;;      (org-cycle)
;;      (bh/insert-inactive-timestamp))))

;; (add-hook 'org-insert-heading-hook 'bh/insert-heading-inactive-timestamp 'append)

(defun bh/clock-in-to-next (kw)
  "Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "TODO"))
           (bh/is-task-p))
      "NEXT")
     ((and (member (org-get-todo-state) (list "NEXT"))
           (bh/is-project-p))
      "TODO"))))

(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun bh/punch-in (arg)
  "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
  (interactive "p")
  (setq bh/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      ;;
      ;; We're in the agenda
      ;;
      (let* ((marker (org-get-at-bol 'org-hd-marker))
             (tags (org-with-point-at marker (org-get-tags-at))))
        (if (and (eq arg 4) tags)
            (org-agenda-clock-in '(16))
          (bh/clock-in-organization-task-as-default)))
    ;;
    ;; We are not in the agenda
    ;;
    (save-restriction
      (widen)
      ; Find the tags on the current task
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
          (org-clock-in '(16))
        (bh/clock-in-organization-task-as-default)))))

(defun bh/punch-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun bh/clock-in-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task))
    (save-excursion
      (save-restriction
        (widen)
        (while (and (not parent-task) (org-up-heading-safe))
          (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
            (setq parent-task (point))))
        (if parent-task
            (org-with-point-at parent-task
              (org-clock-in))
          (when bh/keep-clock-running
            (bh/clock-in-default-task)))))))

(defvar bh/organization-task-id "5215ec32-9154-4cc6-8e60-dd4bd440970c")

(defun bh/clock-in-organization-task-as-default ()
  (interactive)
  (org-with-point-at (org-id-find bh/organization-task-id 'marker)
    (org-clock-in '(16))))

(defun bh/clock-out-maybe ()
  (when (and bh/keep-clock-running
             (not org-clock-clocking-in)
             (marker-buffer org-clock-default-task)
             (not org-clock-resolving-clocks-due-to-idleness))
    (bh/clock-in-parent-task)))

(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

(defun bh/clock-in-task-by-id (id)
  "Clock in a task by id"
  (org-with-point-at (org-id-find id 'marker)
    (org-clock-in nil)))

(defun bh/clock-in-last-task (arg)
  "Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
  (interactive "p")
  (let ((clock-in-to-task
         (cond
          ((eq arg 4) org-clock-default-task)
          ((and (org-clock-is-active)
                (equal org-clock-default-task (cadr org-clock-history)))
           (caddr org-clock-history))
          ((org-clock-is-active) (cadr org-clock-history))
          ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
          (t (car org-clock-history)))))
    (widen)
    (org-with-point-at clock-in-to-task
      (org-clock-in nil))))

(setq org-time-stamp-rounding-minutes (quote (1 1)))

(setq org-agenda-clock-consistency-checks
      (quote (:max-duration "4:00"
              :min-duration 0
              :max-gap 0
              :gap-ok-around ("4:00"))))

(defun bh/toggle-next-task-display ()
  (interactive)
  (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
  (when  (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)
(setq bh/keep-clock-running nil)
(setq org-export-with-timestamps nil)
(setq org-return-follows-link t)

;; Org-clock Settings

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; Sets org-mode for .txt files

(add-to-list 'auto-mode-alist '("TextDB/.*[.]txt$" . org-mode))

;; This opens org-links in the same window - allows for universal argument for side window ;;

(defun org-force-open-current-window ()
  (interactive)
  (let ((org-link-frame-setup (quote
                               ((vm . vm-visit-folder)
                                (vm-imap . vm-visit-imap-folder)
                                (gnus . gnus)
                                (file . find-file)
                                (wl . wl)))
                              ))
    (org-open-at-point)))

;; Depending on universal argument try opening link

(defun org-open-maybe (&optional arg)
  (interactive "P")
  (if arg
      (org-open-at-point)
    (org-force-open-current-window)
    )
  )
;; Redefine file opening without clobbering universal argumnet
(define-key org-mode-map "\C-c\C-o" 'org-open-maybe)

;; Add Created Property to Captured Headlines

(defun add-property-with-date-captured ()
  "Add DATE_CAPTURED property to the current item."
  (interactive)
  (org-set-property "CREATED" (format-time-string "%F - %R")))

(add-hook 'org-capture-before-finalize-hook 'add-property-with-date-captured)

;; Created Property to Todos ;;

;; Allow automatically handing of created/expired meta data.
(require 'org-expiry)
;; Configure it a bit to my liking
(setq
  org-expiry-created-property-name "CREATED" ; Name of property when an item is created
  org-expiry-inactive-timestamps   t         ; Don't have everything in the agenda view
)

(defun mrb/insert-created-timestamp()
  "Insert a CREATED property using org-expiry.el for TODO entries"
  (org-expiry-insert-created)
  (org-back-to-heading)
  (org-end-of-line)
  (insert " ")
)

;; Whenever a TODO entry is created, I want a timestamp
;; Advice org-insert-todo-heading to insert a created timestamp using org-expiry
(defadvice org-insert-todo-heading (after mrb/created-timestamp-advice activate)
  "Insert a CREATED property using org-expiry.el for TODO entries"
  (mrb/insert-created-timestamp)
)
;; Make it active
(ad-activate 'org-insert-todo-heading)

;; Markdown Mode ;;

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))

;; Deft

(require 'deft)
(global-set-key [f8] 'deft)
(setq deft-extensions '("org" "txt" "text" "markdown" "md"))
(setq deft-default-extension "org")
(setq deft-directory "~/Dropbox/TextDB")
(setq deft-recursive t)
(setq deft-text-mode 'org-mode)
(setq deft-use-filter-string-for-filename t)
(setq deft-use-filename-as-title t)
(setq deft-markdown-mode-title-level 2)
 
;;(use-package deft
;;  :bind ("<f8>" . deft)
;;  :commands (deft)
;;  :config (setq deft-directory "~/Dropbox/TextDB/"
;;		deft-recursive t
;;		deft-default-extension "org"
;;		deft-extensions '("org" "txt" "text" "markdown" "md")
;;		deft-text-mode 'org-mode
;;              deft-use-filter-string-for-filename t
;;		deft-use-filename-as-title t
;;		deft-markdown-mode-title-level 2))

;; Zetteldeft

(use-package zetteldeft
  :ensure t
  :after deft
  :config (zetteldeft-set-classic-keybindings))

(org-link-set-parameters
  "zdlink"
  :follow (lambda (str) (zetteldeft--search-filename (zetteldeft--lift-id str)))
  :complete 'efls/zd-complete-link
  :help-echo "Searches provided ID in zetteldeft")

(defun efls/zd-complete-link ()
  "Link completion for `tslink' type links"
  (let* ((file (completing-read "File to link to: "
                (deft-find-all-files-no-prefix)))
         (link (zetteldeft--lift-id file)))
     (unless link (user-error "No file selected"))
     (concat "zdlink:" link)))

;; insert date and time

(defvar current-date-time-format "%Y-%m-%d-%H%M"
  "Format of date to insert with `insert-current-date-time' func
See help of `format-time-string' for possible replacements")

(defvar current-time-format "%a %H:%M:%S"
  "Format of date to insert with `insert-current-time' func.
Note the weekly scope of the command's precision.")

(defun insert-current-date-time ()
  "insert the current date and time into current buffer.
Uses `current-date-time-format' for the formatting the date/time."
       (interactive)
       (insert (format-time-string current-date-time-format (current-time)))
       )

(defun insert-current-time ()
  "insert the current time (1-week scope) into the current buffer."
       (interactive)
       (insert (format-time-string current-time-format (current-time)))
       )

(global-set-key (kbd "M-i") 'insert-current-date-time)
(global-set-key (kbd "M-I") 'insert-current-time)

;; UX Tweaks with modeline and errors

(setq visible-bell nil
      ring-bell-function 'double-flash-mode-line)
(defun double-flash-mode-line ()
  (let ((flash-sec (/ 1.0 20)))
    (invert-face 'mode-line)
    (run-with-timer flash-sec nil #'invert-face 'mode-line)
    (run-with-timer (* 2 flash-sec) nil #'invert-face 'mode-line)
    (run-with-timer (* 3 flash-sec) nil #'invert-face 'mode-line)))

;; Desktop-save-mode

(desktop-save-mode 0)

;; Recent Files List

(recentf-mode t)

(run-at-time nil (* 60 60) 'recentf-save-list)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

;; Resize windows, Windmove and other tweaks

(global-set-key (kbd "M-[") 'enlarge-window)
(global-set-key (kbd "M-]") 'shrink-window)
(global-set-key (kbd "C-{") 'enlarge-window-horizontally)
(global-set-key (kbd "C-}") 'shrink-window-horizontally)

(global-set-key (kbd "H-<left>")  'windmove-left)
(global-set-key (kbd "H-<right>") 'windmove-right)
(global-set-key (kbd "H-<up>")    'windmove-up)
(global-set-key (kbd "H-<down>")  'windmove-down)

(define-key minibuffer-local-map (kbd "M-p") 'previous-complete-history-element)
(define-key minibuffer-local-map (kbd "M-n") 'next-complete-history-element)

(defun transform-square-brackets-to-round-ones(string-to-transform)
  "Transforms [ into ( and ] into ), other chars left unchanged."
  (concat 
  (mapcar #'(lambda (c) (if (equal c ?\[) ?\( (if (equal c ?\]) ?\) c))) string-to-transform))
  )

(defun switch-to-minibuffer-window ()
  "switch to minibufferx window (if active)"
  (interactive)
  (when (active-minibuffer-window)
    (select-window (active-minibuffer-window))))

;; (global-set-key (kbd "C-c C-9") 'switch-to-minibuffer-window) ;; unnecessary?
;; (global-set-key (kbd "M-o") 'other-window) ;; making room to ace window
;; (global-set-key (kbd "M-i") 'imenu) ;; didn't use it

;; Org Wiki - Superseded by Zettelldeft and Org-Roam - Less Powerful

;; (require 'org-wiki)
;; (setq org-wiki-location-list
;;      '(
;;        "~/Dropbox/org-wiki/"    ;; First wiki (root directory) is the default. 
;;        "~/Dropbox/TextDB/"
;;       ))
;; (setq org-wiki-location (car org-wiki-location-list))

;; New File Capture Template Function

(defun psachin/create-notes-file ()
  "Create an org file in ~/Dropbox/TextDB/."
  (interactive)
  (let ((name (read-string "Filename: ")))
    (expand-file-name (format "%s.org"
                                name) "~/Dropbox/TextDB/")))

;; Rename File and Buffer (by Steve Yegge)

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;; Org Capture Templates

(setq org-capture-templates '(
      ("t" "Todo" entry (file "~/Dropbox/org/refile.org")
       "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
      ("tl" "Ligacão" entry (file "~/Dropbox/org/refile.org")
       "* PHONE %? :ligacão:\n%U" :clock-in t :clock-resume t)
      ("e" "Responder Email" entry (file "~/Dropbox/org/refile.org")
       "* TODO  Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
      ("n" "Note" entry (file "~/Dropbox/org/refile.org")
       "* %? :note:\n%U\n%a\n" :clock-in t :clock-resume t)
      ("r" "Reunião" entry (file "~/Dropbox/org/refile.org")
       "* Reunião com %? :reunião:\n%U" :clock-in t :clock-resume t)
      ("s" "Selection (on emacs)" entry (file "~/Dropbox/org/refile.org")
       "* %i%? - %U")		       
      ("c" "Clipboard" entry (file "~/Dropbox/org/refile.org")
       "* %c%? - %U")
      ("o" "Org Store Link (on emacs)" entry (file "~/Dropbox/org/refile.org")
       "* %a%? - %U")
      ("m" "Music" entry (file+headline "~/Dropbox/org/refile.org" "Music on Radar")
       "* %?Music")
      ("mo" "Movies" entry (file+headline "~/Dropbox/org/refile.org" "Movies to Watch")
       "* %?Movie")
      ("b" "Books" entry (file+headline "~/Dropbox/org/refile.org" "Books to Read")
       "* %?Book")
      ("g" "Games" entry (file+headline "~/Dropbox/org/refile.org" "Games to Play")
       "* %?Game")
      ("s" "TV Series" entry (file+headline "~/Dropbox/org/refile.org" "TV Series to Watch")
       "* %?Series")
      ("!" "New File @ TextDB" entry (file psachin/create-notes-file)
       "* TITLE%?\n %U")
      ("p" "Protocol" entry (file "~/Dropbox/org/inbox.org")
       "* %^{Title}\nSource: %U, %a\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n")
      ("L" "Protocol Link" entry (file "~/Dropbox/org/inbox.org")
       "* %(transform-square-brackets-to-round-ones \"%:description\")\nSource: %:link - captured on: %U")
      ))

;; Systemwide Org-Capture with separate frame
;;
;; to call org capture from anywhere in my system via emacsclient -c -F '(quote (name . "capture"))' -e '(activate-capture-frame)'
;; to setup extension check https://github.com/sprig/org-capture-extension

(defadvice org-switch-to-buffer-other-window
  (after supress-window-splitting activate)
  "Delete the extra window if we're in a capture frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-other-windows)))

(defadvice org-capture-finalize
(after delete-capture-frame activate)
  "Advise capture-finalize to close the frame"
  (when (and (equal "capture" (frame-parameter nil 'name))
	     (not (eq this-command 'org-capture-refile)))
(delete-frame)))

(defadvice org-capture-refile
(after delete-capture-frame activate)
  "Advise org-refile to close the frame"
  (delete-frame))

(defun activate-capture-frame ()
  "run org-capture in capture frame"
  (select-frame-by-name "capture")
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (org-capture))

;;SaveHist Mode

(savehist-mode 1);
(add-to-list 'savehist-additional-variables 'kill-ring) 

;; Default Font

(add-to-list 'default-frame-alist '(font . "Fira Code-13" ))
(set-face-attribute 'default t :font "Fira Code-13" )

;; Org-Refile Tweaks (by Aaron Bieber)

(setq org-refile-use-outline-path 'file) ;; Allow refile to top level
(setq org-outline-path-complete-in-steps nil) ;; Make above work properly in Helm
(setq org-refile-allow-creating-parent-nodes 'confirm) ;; Allow creating parent node on-the-fly

;; Real-Auto-Save

(require 'real-auto-save)
(setq real-auto-save-use-idle-timer nil)
(add-hook 'org-mode-hook 'real-auto-save-mode)

;; Org-Superstar

(require 'org-superstar)
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))

;;CONSIDERING THIS IN OR OUT!

(setq org-hide-emphasis-markers t)

;; Display-Buffer

;; The default behaviour of `display-buffer' is to always create a new
;; window. As I normally use a large display sporting a number of
;; side-by-side windows, this is a bit obnoxious.
;;
;; The code below will make Emacs reuse existing windows, with the
;; exception that if have a single window open in a large display, it
;; will be split horisontally.

;; (setq pop-up-windows nil)

;; (defun my-display-buffer-function (buf not-this-window)
;;  (if (and (not pop-up-frames)
;;           (one-window-p)
;;	   (or not-this-window
;;               (not (eq (window-buffer (selected-window)) buf)))
;;           (> (frame-width) 162))
;;      (split-window-horizontally))

;;  ;; Note: Some modules sets `pop-up-windows' to t before
;;  ;; calling `display-buffer' -- Why, oh, why!

;;  (let ((display-buffer-function nil)
;;        (pop-up-windows nil))
;;    (display-buffer buf not-this-window)))

;;(setq display-buffer-function 'my-display-buffer-function)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(auto-save-default nil)
 '(auto-save-interval 30)
 '(auto-save-list-file-prefix "~/.emacssaves/.saves-")
 '(auto-save-timeout 10)
 '(auto-save-visited-file-name nil)
 '(auto-save-visited-interval 10)
 '(auto-save-visited-mode nil)
 '(backup-by-copying t)
 '(backup-directory-alist (quote (("." . "~/.emacsbackups/"))))
 '(compilation-message-face (quote default))
 '(create-lockfiles nil)
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-mode nil nil (cua-base))
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes (quote (whiteboard)))
 '(custom-safe-themes
   (quote
    ("30289fa8d502f71a392f40a0941a83842152a68c54ad69e0638ef52f04777a4c" "2d035eb93f92384d11f18ed00930e5cc9964281915689fa035719cab71766a15" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" default)))
 '(delete-auto-save-files nil)
 '(delete-old-versions t)
 '(desktop-auto-save-timeout 30)
 '(desktop-path (quote ("~/")))
 '(emms-cache-get-function (quote emms-cache-get))
 '(emms-cache-modified-function (quote emms-cache-dirty))
 '(emms-cache-set-function (quote emms-cache-set))
 '(emms-info-functions
   (quote
    (emms-info-cueinfo emms-info-opusinfo emms-info-ogginfo)))
 '(emms-mode-line-mode-line-function (quote emms-mode-line-icon-function))
 '(emms-ok-track-function (quote emms-score-ok-track-function))
 '(emms-player-list
   (quote
    (emms-player-mplayer emms-player-mplayer-playlist emms-player-mpv emms-player-vlc emms-player-vlc-playlist emms-player-mpg321 emms-player-ogg123)))
 '(emms-playlist-update-track-function (quote emms-playlist-mode-update-track-function))
 '(emms-source-file-default-directory "/mnt/")
 '(emms-track-description-function (quote emms-info-track-description))
 '(enable-local-variables :all)
 '(fci-rule-color "#f8fce8")
 '(fill-column 80)
 '(global-auto-revert-mode t)
 '(global-visual-line-mode t)
 '(helm-completion-style (quote emacs))
 '(helm-mode t)
 '(helm-split-window-default-side (quote below))
 '(helm-split-window-inside-p t)
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (quote
    ("#eef6d970af00" "#cef5e0cccfbb" "#fd55c91cb29c" "#dadbd2efdc17" "#e0a3de02afa1" "#f84bcba1ad99" "#d28bd9ebdf8a")))
 '(highlight-symbol-foreground-color "#586e75")
 '(highlight-tail-colors
   (quote
    (("#eee8d5" . 0)
     ("#b3c34d" . 20)
     ("#6ccec0" . 30)
     ("#74adf5" . 50)
     ("#e1af4b" . 60)
     ("#fb7640" . 70)
     ("#ff699e" . 85)
     ("#eee8d5" . 100))))
 '(hl-bg-colors
   (quote
    ("#e1af4b" "#fb7640" "#ff6849" "#ff699e" "#8d85e7" "#74adf5" "#6ccec0" "#b3c34d")))
 '(hl-fg-colors
   (quote
    ("#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3")))
 '(hl-paren-background-colors (quote ("#e8fce8" "#c1e7f8" "#f8e8e8")))
 '(hl-paren-colors (quote ("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900")))
 '(ido-enable-flex-matching t)
 '(ido-ignore-buffers (quote ("\\` " "\\`*helm")))
 '(ido-mode (quote both) nil (ido))
 '(ido-use-filename-at-point (quote guess))
 '(line-spacing 0.2)
 '(list-matching-lines-default-context-lines 3)
 '(lsp-ui-doc-border "#586e75")
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 1) ((control)))))
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#5b7300" "#b3c34d" "#0061a8" "#2aa198" "#d33682" "#6c71c4")))
 '(org-agenda-files
   (quote
    ("~/Dropbox/org/" "~/Dropbox/org/org-awesome/" "~/Dropbox/org/MediaDB/" "~/Dropbox/OrgRoam/" "~/Dropbox/TextDB/")))
 '(org-archive-location "~/Dropbox/org/archive.org::* From %s")
 '(org-capture-templates
   (quote
    (("t" "Todo" entry
      (file "~/Dropbox/org/refile.org")
      "* TODO %?
%U
%a
" :clock-in t :clock-resume t)
     ("tl" "Ligacão" entry
      (file "~/Dropbox/org/refile.org")
      "* PHONE %? :ligacão:
%U" :clock-in t :clock-resume t)
     ("e" "Responder Email (on emacs)" entry
      (file "~/Dropbox/org/refile.org")
      "* TODO  Respond to %:from on %:subject
SCHEDULED: %t
%U
%a
" :immediate-finish t :clock-in t :clock-resume t)
     ("n" "Note" entry
      (file "~/Dropbox/org/refile.org")
      "* %? :note:
%U
%a
" :clock-in t :clock-resume t)
     ("r" "Reunião" entry
      (file "~/Dropbox/org/refile.org")
      "* Reunião com %? :reunião:
%U" :clock-in t :clock-resume t)
     ("j" "Journal" entry
      (function org-journal-find-location)
      "* %(format-time-string org-journal-time-format)%^{Title}%i%?" :clock-in t :clock-resume t)
     ("s" "Selection (on emacs)" entry
      (file "~/Dropbox/org/refile.org")
      "* %i%? - %U")
     ("c" "Clipboard" entry
      (file "~/Dropbox/org/refile.org")
      "* %c%? - %U")
     ("o" "Org Store Link (on emacs)" entry
      (file "~/Dropbox/org/refile.org")
      "* %a%? - %U")
     ("m" "Music" entry
      (file+headline "~/Dropbox/org/refile.org" "Music on Radar")
      "* %?:music:")
     ("h" "Movies" entry
      (file+headline "~/Dropbox/org/refile.org" "Movies to Get")
      "* %?:movie:")
     ("b" "Books" entry
      (file+headline "~/Dropbox/org/refile.org" "Books to Read")
      "* %?:book:")
     ("g" "Games" entry
      (file+headline "~/Dropbox/org/refile.org" "Games to Play")
      "* %?:game:")
     ("v" "TV Series" entry
      (file+headline "~/Dropbox/org/refile.org" "TV Series to Watch")
      "* %?:series:")
     ("!" "New File @ TextDB" entry
      (file psachin/create-notes-file)
      "* TITLE%?
 %U")
     ("p" "Protocol" entry
      (file "~/Dropbox/org/inbox.org")
      "* %^{Title}
Source: %U, %a
 #+BEGIN_QUOTE
%i
#+END_QUOTE

")
     ("L" "Protocol Link" entry
      (file "~/Dropbox/org/inbox.org")
      "* %(transform-square-brackets-to-round-ones \"%:description\")
Source: %:link - captured on: %U"))))
 '(org-catch-invisible-edits (quote smart))
 '(org-clock-idle-time 10)
 '(org-clock-sound t)
 '(org-complete-tags-always-offer-all-agenda-tags t)
 '(org-default-notes-file "~/Dropbox/org/Notes.org")
 '(org-default-priority 67)
 '(org-directory "~/Dropbox/org/")
 '(org-indent-indentation-per-level 3)
 '(org-indent-mode-turns-on-hiding-stars nil)
 '(org-journal-date-format "%A, %d %B %Y" t)
 '(org-journal-date-prefix "#+title: " t)
 '(org-journal-dir "~/Dropbox/OrgRoam/Journal/" t)
 '(org-journal-file-format "%Y-%m-%d.org" t)
 '(org-lowest-priority 69)
 '(org-refile-allow-creating-parent-nodes (quote confirm))
 '(org-refile-targets
   (quote
    ((nil :maxlevel . 9)
     (org-agenda-files :tag . "heading")
     (org-agenda-files :todo . "TODO")
     (org-agenda-files :level . 1)
     (org-agenda-files :tag . "target"))))
 '(org-refile-use-outline-path (quote file))
 '(org-roam-completion-system (quote helm))
 '(org-roam-directory "~/Dropbox/OrgRoam/")
 '(org-show-context-detail
   (quote
    ((agenda . local)
     (bookmark-jump . lineage)
     (isearch . lineage)
     (default . ancestors)
     (occur-tree . ancestors))))
 '(org-startup-indented t)
 '(org-support-shift-select t)
 '(org-tags-column 0)
 '(org-tags-exclude-from-inheritance (quote ("heading")))
 '(org-tags-match-list-sublevels t)
 '(org-use-speed-commands nil)
 '(org-web-tools-pandoc-sleep-time 1.0)
 '(package-load-list (quote (all)))
 '(package-selected-packages
   (quote
    (emms org-journal olivetti org-roam yasnippet org-plus-contrib default-text-scale org-web-tools org-bookmark-heading ivy ace-window markdown-mode gnu-elpa-keyring-update zetteldeft plan9-theme org-wiki avy company solarized-theme emacsql-sqlite3 use-package deft real-auto-save exec-path-from-shell pandoc-mode pandoc s helm)))
 '(pos-tip-background-color "#eee8d5")
 '(pos-tip-foreground-color "#586e75")
 '(recentf-max-menu-items 10)
 '(recentf-max-saved-items 30)
 '(recentf-save-file "~/recentf")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(sml/active-background-color "#98ece8")
 '(sml/active-foreground-color "#424242")
 '(sml/inactive-background-color "#4fa8a8")
 '(sml/inactive-foreground-color "#424242")
 '(term-default-bg-color "#fdf6e3")
 '(term-default-fg-color "#657b83")
 '(tool-bar-mode nil)
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#ca7966832090")
     (60 . "#c05578c91534")
     (80 . "#b58900")
     (100 . "#a6088eed0000")
     (120 . "#9e3a91a60000")
     (140 . "#9628943b0000")
     (160 . "#8dc596ad0000")
     (180 . "#859900")
     (200 . "#76ef9b6045e8")
     (220 . "#6cd69ca95b9d")
     (240 . "#5f5f9e06701f")
     (260 . "#4c1a9f778424")
     (280 . "#2aa198")
     (300 . "#3002984eaf4d")
     (320 . "#2f6f93e8bae0")
     (340 . "#2c598f79c66f")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(version-control t)
 '(weechat-color-list
   (quote
    (unspecified "#fdf6e3" "#eee8d5" "#a7020a" "#dc322f" "#5b7300" "#859900" "#866300" "#b58900" "#0061a8" "#268bd2" "#a00559" "#d33682" "#007d76" "#2aa198" "#657b83" "#839496")))
 '(window-divider-mode t)
 '(xterm-color-names
   ["#eee8d5" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#073642"])
 '(xterm-color-names-bright
   ["#fdf6e3" "#cb4b16" "#93a1a1" "#839496" "#657b83" "#6c71c4" "#586e75" "#002b36"]))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(italic ((t (:underline nil :slant italic :family "Fira Sans-11")))))
