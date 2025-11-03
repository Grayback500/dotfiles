;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
;;; code:
;;; Custom load path:
(add-to-list 'custom-theme-load-path "~/usr/share/emacs/30.1/etc/themes")
(setq doom-theme 'base16-eighties)


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;; Menu bar
;; Enable menu-bar-mode
(after! doom
  (menu-bar-mode +1))
;;
;;; Font Size
;; (for Windows because this is wayy too small)
(cond
 ((string-equal system-name "kyoto")
  (setq doom-font (font-spec :size 13)))
 ((string-equal system-name "isaiahfishbowl")
  (setq doom-font (font-spec :size 18))))
;;
;;
;;
;;; LSP MODE auto serach and boot
(after! lsp-mode
  (setq lsp-auto-guess-root t)       ; Try to guess the project root
  (setq lsp-restart 'auto-restart)   ; Automatically restart servers if needed
)
;;
;;; Configure the Python LSP client (pylsp)
(after! lsp-python
  (setq lsp-python-ms-auto-install-server t) ; Auto-install if missing
  ;; Ensure it can find your Python installation
  (setq lsp-python-ms-python-executable "python") ; or full path like "C:/Python39/python.exe"
  (setq lsp-signature-auto-activate '(:on-trigger-char :after-completion))
  (setq lsp-signature-doc-lines 3)
)
;;
;;; Enable LSP for Python files with deferred loading
(add-hook 'python-mode-hook #'lsp-deferred)
;;
;; Quick property setup - Properties for Org Pomodoro Studying
(defun my/org-quick-properties ()
  "Quickly add standard properties to current heading."
  (interactive)
  (org-set-property "EFFORT" "1h")
  (org-set-property "POMODOROS" "0"))

;; Enhanced clock in/out with pomodoro counting
(defun my/org-study-clock-in ()
  "Start studying a task with pomodoro tracking."
  (interactive)
  (org-clock-in)
  (message "Study session started! Press f9 when done."))

(defun my/org-study-clock-out ()
  "Finish studying and log the pomodoro."
  (interactive)
  (let ((pomos (string-to-number (or (org-entry-get (point) "POMODOROS") "0"))))
    (org-clock-out)
    (org-set-property "POMODOROS" (number-to-string (+ 1 pomos)))
    (message "Session complete! You've done %d pomodoros on this task." (+ 1 pomos))))

;; Wait until org-mode is loaded before setting keybindings
(after! org
  (define-key org-mode-map (kbd "<f7>") 'my/org-quick-properties) ; properties
  (define-key org-mode-map (kbd "<f8>") 'my/org-study-clock-in) ; clock in
  (define-key org-mode-map (kbd "<f9>") 'my/org-study-clock-out)) ; clock out

;; Setup for ispell on org files
(setq ispell-program-name "hunspell")

;; Automatically open Treemacs on non-Org buffers
(add-hook 'find-file-hook
  (lambda ()
    (unless (derived-mode-p 'org-mode)
      (unless (treemacs-current-visibility)
        (treemacs)))))

;; Global Treemacs keybinds
(global-set-key (kbd "C-x t t") #'treemacs)
(global-set-key (kbd "C-x t b") #'treemacs-select-window)
;;; config.el ends here
