;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "waytrue"
user-mail-address "waytrue@outlook.com")

;;(setq mac-command-modifier      'super
;;      ns-command-modifier       'super
;;      mac-option-modifier       'meta
;;      ns-option-modifier        'meta
;;      mac-right-option-modifier 'meta
;;      ns-right-option-modifier  'none)
;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))
  ;; Set default font
  (cl-loop for font in '("JetBrainsMono Nerd Font"
                         "Menlo" "Monaco" "DejaVu Sans Mono" "Consolas")
           when (font-installed-p font)
           return (set-face-attribute 'default nil
                                      :font font
                                      :height  160))

  ;; Specify font for all unicode characters
  (cl-loop for font in '("Apple Color Emoji" "Segoe UI Symbol" "Symbola" "Symbol")
           when (font-installed-p font)
           return(set-fontset-font t 'unicode font nil 'prepend))
  (cl-loop for font in '("Sarasa Mono SC Nerd" "WenQuanYi Micro Hei" "WenQuanYi Zen Hei" "Microsoft Yahei")
           when (font-installed-p font)
           return (set-fontset-font t '(#x4e00 . #x9fff) font))
(defun my-frame-init()
  (cl-loop for font in '("JetBrainsMono Nerd Font"
                         "Menlo" "Monaco" "DejaVu Sans Mono" "Consolas")
           when (font-installed-p font)
           return (set-face-attribute 'default nil
                                      :font font
                                      :height  160))

  ;; Specify font for all unicode characters
  (cl-loop for font in '("Apple Color Emoji" "Segoe UI Symbol" "Symbola" "Symbol")
           when (font-installed-p font)
           return(set-fontset-font t 'unicode font nil 'prepend))
  (cl-loop for font in '("Sarasa Mono SC Nerd" "WenQuanYi Micro Hei" "WenQuanYi Zen Hei" "Microsoft Yahei")
           when (font-installed-p font)
           return (set-fontset-font t '(#x4e00 . #x9fff) font))
  )

(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (select-frame frame)
                (my-frame-init)))
  (my-frame-init))
  ;; Specify font for Chinese characters
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-snazzy)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `nil)


;; Here are some additional functions/macros that could help you configure Doom:
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

;; Basic Improve
  (winner-mode +1)

;; Key-Binding
(setq mac-command-modifier      'super
      ns-command-modifier       'super
      mac-option-modifier       'none
      ns-option-modifier        'none
      mac-right-option-modifier 'meta
      ns-right-option-modifier  'meta)


(global-set-key (kbd "C-c n a") 'my/annot)
(global-set-key (kbd "M-<backspace>") 'org-mark-ring-goto)
(global-set-key (kbd "C-x C-c") 'kill-emacs)
(define-key winner-mode-map (kbd "<s-left>") #'winner-undo)
(define-key winner-mode-map (kbd "<s-right>") #'winner-redo)
(define-key evil-normal-state-map (kbd "S") #'save-buffer)
(evil-define-key 'insert org-mode-map
     (kbd "[ [") 'my/insert-roam-link)
(evil-define-key 'normal org-mode-map
     (kbd "[ [") 'my/changeinto-roam-link)
(evil-define-key 'motion org-mode-map
     (kbd "[ [") 'my/changeinto-roam-link)
(defun my/auto-highlight()
    "changeinto-highlight"
    (interactive)
    (backward-kill-word 1)
    (insert "==")
    (yank 1)
    (insert "=="))

(defun my/changeinto-roam-link ()
    "changeinto-Org-roam link."
    (interactive)
    (evil-delete evil-visual-mark evil-visual-end)
    (my/insert-roam-link)
    (yank 1)
    (forward-char 2))
(defun my/insert-roam-link ()
    "Inserts an Org-roam link."
    (interactive)
    (insert "[[roam:]]")
    (backward-char 2))
(use-package! deft
  :init
  (setq
        deft-extensions '("org" "md")
        deft-recursive t)
  )
(use-package! org-roam
  :hook (after-init . org-roam-setup)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n k" . org-id-get-create)
         ("C-c n v" . org-roam-preview-visit)
         ("C-c n t" . org-roam-dailies-capture-today)
         ("C-c n I" . org-roam-insert-immediate))
  :init
  (setq org-roam-directory "~/Study/garden2"
        org-roam-capture-templates
        '(
         ("d" "default" plain "" :target
          (file+head "./pages/${slug}.org" "#+title: ${title} \n#+creationTime: %U \n")
          :unnarrowed t
         ;; :immediate-finish t
          :kill-buffer t
          :jump-to-captured -1)
         ("e" "default" plain "" :target
          (file+head "./English/${slug}.org" "#+title: ${title} \n#+creationTime: %U \n")
          :unnarrowed t
         ;; :immediate-finish t
          :kill-buffer t
          :jump-to-captured -1)
         ("z" "default" plain "" :target
          (file+head "./??????/${slug}.org" "#+title: ${title} \n#+creationTime: %U \n")
          :unnarrowed t
         ;; :immediate-finish t
          :kill-buffer t
          :jump-to-captured -1)
         ("c" "cards" plain "" :target (file+head "./pages/${slug}.org" "#+title: ${title} \n#+creationTime: %U \n\n\n* Keywords\n- \n* Contents\n* Mnemonic\n* Reference")
          :unnarrowed t
          ;;:immediate-finish t
          :kill-buffer
          :jump-to-captured -1)
         )))

(setq org-directory org-roam-directory
      deft-directory org-roam-directory)
(defun zz/org-download-paste-clipboard (&optional use-default-filename)
  (interactive "P")
  (require 'org-download)
  (let ((file
         (if (not use-default-filename)
             (read-string (format "Filename [%s]: "
                                  org-download-screenshot-basename)
                          nil nil org-download-screenshot-basename)
           nil)))
    (org-download-clipboard file)))

(after! org
  (setq org-download-method 'directory)
  (setq org-download-image-dir (concat org-roam-directory "assets"))
  (setq org-download-heading-lvl nil)
  (setq org-download-timestamp "%Y%m%d-%H%M%S_")
  (evil-snipe-mode -1)
  (setq org-image-actual-width 300)
  (map! :map org-mode-map
        "C-c l a y" #'zz/org-download-paste-clipboard
        "C-M-y" #'zz/org-download-paste-clipboard))
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(use-package! org-transclusion
  :after org
  :init
  (map!
   :map global-map "<f12>" #'org-transclusion-add
   :leader
   :prefix "n"
   :desc "Org Transclusion Mode" "t" #'org-transclusion-mode))
(use-package! valign
  :hook (org-mode . valign-mode))
 (set-frame-parameter (selected-frame)'alpha '(90 . 90))
 (add-to-list 'default-frame-alist'(alpha . (90 . 90)))

;(use-package! org-superstar
;  :ensure t
;  :hook (org-mode . org-superstar-mode)
;  :config
;  (setq org-superstar-item-bullet-alist '((?- . ????)))
;  (setq org-superstar-headline-bullets-list
;  '("???" "???" "???" "???" "???" "???" "???" "???" "???" "???"))
;  )
(defun set-region-read-only (begin end)
  "Sets the read-only text property on the marked region.

Use `set-region-writeable' to remove this property."
  ;; See http://stackoverflow.com/questions/7410125
  (interactive "r")
  (let ((modified (buffer-modified-p)))
    (add-text-properties begin end '(read-only t))
    (set-buffer-modified-p modified)))

(defun set-region-writeable (begin end)
  "Removes the read-only text property from the marked region.

Use `set-region-read-only' to set this property."
  ;; See http://stackoverflow.com/questions/7410125
  (interactive "r")
  (let ((modified (buffer-modified-p))
        (inhibit-read-only t))
    (remove-text-properties begin end '(read-only t))
    (set-buffer-modified-p modified)))
(defun global-set-region-read-only ()
    (interactive)
(save-excursion
(goto-char (point-min))
    (while (re-search-forward "^ *:\\(\\(PROPERTIES\\)\\|\\(LOGBOOK\\)\\|\\(LOGNOTE\\)\\):\n\\(.*\n\\)*? *:END:\n" nil t)
      (set-region-read-only (match-beginning 0) (match-end 0)))
    ))
(add-hook 'org-mode-hook #'global-set-region-read-only)
(use-package! org-modern
  :after org
  :config
  (add-hook 'org-mode-hook #'org-modern-mode))
(after! org
  (setq org-startup-indented t
        org-modern-hide-stars nil
        org-modern-keyword "???"
        org-modern-list '((43 . "???") (45 . "???") (42 . "???"))
        org-modern-star ["???" "???" "???" "???" "???" "???" "???" "???" "???" "???"]
        org-modern-table nil)
  )

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done note)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook #'org-summary-todo)

;;(defun my/changeinput2en()
;;    "this is a function automatic changing input method to en"
;;  (interactive)
;;(if (eq major-mode 'org-mode)
;;  (shell-command "macism com.apple.keylayout.ABC")))
;;
;;(defun my/changeinput2cn()
;;    "this is a function automatic changing input method to en"
;;  (interactive)
;;(if (eq major-mode 'org-mode)
;;  (shell-command "macism im.rime.inputmethod.Squirrel.Rime")))
;;
;;(add-hook 'evil-insert-state-entry-hook #'my/changeinput2cn)
;;(add-hook 'evil-insert-state-exit-hook #'my/changeinput2en)
(add-hook 'evil-insert-state-exit-hook #'save-buffer)
(add-hook 'org-capture-before-finalize-hook #'org-mark-ring-push)
;;(use-package! sis
;;  ;; :hook
;;  ;; enable the /follow context/ and /inline region/ mode for specific buffers
;;  ;; (((text-mode prog-mode) . sis-context-mode)
;;  ;;  ((text-mode prog-mode) . sis-inline-mode))
;;
;;  :config
;;  ;; For MacOS
;;  (sis-ism-lazyman-config
;;
;;   ;; English input source may be: "ABC", "US" or another one.
;;   "com.apple.keylayout.ABC"
;;   ;;"com.apple.keylayout.US"
;;
;;   ;; Other language input source: "rime", "sogou" or another one.
;;   ;; "im.rime.inputmethod.Squirrel.Rime"
;;   ;;"com.sogou.inputmethod.sogou.pinyin"
;;   "im.rime.inputmethod.Squirrel.Rime")
;;  ;; enable the /cursor color/ mode
;;  (sis-global-cursor-color-mode nil)
;;  ;; enable the /respect/ mode
;;  (sis-global-respect-mode t)
;;  ;; enable the /context/ mode for all buffers
;;  (sis-global-context-mode t)
;;  ;; enable the /inline english/ mode for all buffers
;;  (sis-global-inline-mode t)
;;  )
(use-package! rime
  :config
  (setq rime-share-data-dir "/Users/waytrue/Library/Rime")
  (setq rime-user-data-dir "/Users/waytrue/Library/Rime")
  :custom
  (default-input-method "rime")
  (rime-emacs-module-header-root "/opt/homebrew/Cellar/emacs-plus@28/28.2/include")
  (rime-librime-root "~/.emacs.d/librime/dist"))
(use-package! org-pomodoro
  :config
  (setq org-pomodoro-length 35)
  (setq org-pomodoro-long-break-length 10)
  )
(defun my/org-pomodoro-restart ()
  (interactive)
    (save-window-excursion
      (org-clock-goto)
      (org-pomodoro)))

(add-hook 'org-pomodoro-break-finished-hook 'my/org-pomodoro-restart)
