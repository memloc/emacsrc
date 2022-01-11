;; Straight for version control based package management
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Declarative package management with leaf (similar to `use-package')
(eval-and-compile
  (straight-use-package 'leaf)
  (straight-use-package 'leaf-keywords)
  (require 'leaf)
  (require 'leaf-keywords)
  (leaf-keywords-init))

(leaf leaf
  "Declarative package manager"
  :url "https://github.com/conao3/leaf.el#description")

(leaf diminish
  "This package implements hiding or abbreviation of the mode line displays
(lighters) of minor-modes."
  :url "https://github.com/myrjola/diminish.el"
  :straight t
  :require t)

(leaf async
  "Adds the ability to call asynchronous functions and process with ease. For
instance `async-bytecomp'."
  :url "https://github.com/jwiegley/emacs-async"
  :straight t
  :leaf-defer nil
  :setq (async-bytecomp-package-mode . t))

(leaf gcmh
  "Smart garbage collecting, which sets a high GC threshold during normal use
to avoid interference with work; low GC threshold when idling."
  :url "https://gitlab.com/koral/gcmh"
  :straight t
  :require t
  :init (setq gc-cons-threshold (* 50 1000 1000))
  :hook (add-hook 'after-init-hook
				  (lambda ()
					(setq gc-cons-threshold (* 2 1000 1000))))
  :setq (garbage-collection-messages . t)) ;; Announce when GC

(leaf no-littering
  "Attempts to keep ./emacs.d clean by redirecting the values of path variables to
be more consistent (defaulting to `etc/') and relocating any persistent data files
to `var/'"
  :url "https://github.com/emacscollective/no-littering"
  :straight t
  :setq (auto-save-file-name-transforms . `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))


;; Window Settings
(when window-system
  (tooltip-mode 0)
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
  (set-fringe-mode 10)
  (blink-cursor-mode -1)
  ;; Font Settings
  (progn (defvar default-font-size 90)
		 (defvar default-variable-font-size 90)
 		 (set-face-attribute 'default nil :font "Rec Mono Linear" :height default-font-size)
 		 (set-face-attribute 'fixed-pitch nil :font "Rec Mono Linear" :height default-font-size)
 		 (set-face-attribute 'variable-pitch nil :font "Rec Mono Linear" :height default-font-size)))

;; Editor Defaults
(setq-default
 ring-bell-function 'ignore            ; prevent beep 
 create-lockfiles nil                  ; don't create .#locked-file-name
 comfirm-kill-process nil              ; exit emacs without asking to kill processes
 backup-by-copying t                   ; prevent linked files
 delete-old-versions t                 ; don't ask to delete old backup files
 window-resize-pixelwise t)            ; correctly resize windows by pixels (e.g. in split-window functions)
 
;; Suppress GUI features
(setq use-file-dialog nil
      use-dialog-box nil
      inhibit-startup-screen t
      inhibit-startup-echo-area-message t)

;; Optimization
(setq idle-update-delay 1.0)
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t)
(setq redisplay-skip-fontification-on-input t)

;; Mouse-wheel scrolling
(setq mouse-wheel-scroll-amount '(0.07))
(setq mouse-wheel-progressive-speed nil)

;; Whitespace settings
(setq-default tab-width 4)
;;(setq-default electric-indent-inhibit t)

;; Parentheses Settings
(show-paren-mode 1)

;; Line Numbers enabled by default
(column-number-mode t)
(global-display-line-numbers-mode t)
;; Toggle off line numbering in the following modes
(dolist (mode '(org-mode-hook
		vterm-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Highlight lines enabled by default
(global-hl-line-mode 1)
;; Toggle off line highlighting in the following modes
(dolist (mode '(vterm-mode-hook))
  (add-hook mode (lambda () (hl-line-mode nil))))

;; Shorten yes or no prompts
(fset 'yes-or-no-p 'y-or-n-p)

(leaf general
  "A convenient method for binding keys (with support for evil users)."
  :url "https://github.com/noctuid/general.el"
  :straight t
  :config
  (general-define-key
   :keymaps 'global-map
  (general-evil-setup)))

(leaf evil
  "Extensible vi layer for emacs, which emulates the main features of vim."
  :url "https://github.com/emacs-evil/evil"
  :straight t
  :init
  (general-setq evil-disable-insert-state-bindings t)
  (general-setq evil-want-C-u-scroll t)
  (general-setq evil-want-keybinding nil)
  (general-setq evil-want-integration t)
  :config
  (evil-mode)
  (leaf evil-collection
	"A collection of `Evil' bindings for the parts of emacs which evil does not
cover by default."
	:url "https://github.com/emacs-evil/evil-collection"
	:straight t
	:config (evil-collection-init)))

;;
;; Grouped Backends
;; ================
;; An element of `company-backends' can also be a list of backends. The completions from
;; backends in such groups are merged, but only from those backends which return the same
;; `prefix'.
;;
;; The group can also contain keywords. Currently, `:with', and `:separate' keywords are
;; defined. If the group contains the keyword `:with', the backends listed after this keyword
;; are ignored for the purpose of the `prefix' command. If the group contains the keyword
;; `:separate', the candidates that come from different backends are stored separately in
;; the combined list.
;;

(leaf company
  "Modular completion framework, where the modules for retrieving completion candidates
are called backends, and the modules for displaying them are frontends."
  :url "https://company-mode.github.io/"
  :straight t
  :diminish company-mode
  :hook (after-init-hook . global-company-mode)
  :custom
  (company-idle-delay . 0)
  (company-echo-delay . 0)
  (company-minimum-prefix-length . 0)
  (company-require-match . nil)
  (company-dabbrev-ignore-case . nil)
  (company-dabbrev-downcase . nil)
  (company-echo-truncate-lines . t)
  (company-tooltip-align-annotations . t)
  (company-tng-auto-configure . nil)

  ;; avoid resizing of popup while typing.
  (company-tooltip-maximum-width . 60)
  (company-tooltip-minimum-width . 60)

  (company-backends . '((company-yasnippet company-capf :separate company-dabbrev-code company-keywords)
						 company-files
						 company-keywords
						 company-capf
						 company-abbrev
						 company-dabbrev))

  (company-global-modes . '(not
                            erc-mode message-mode help-mode
                            gud-mode eshell-mode shell-mode))
   :bind
  (("M-/" . company-yasnippet)
   (:company-active-map
    ("C-k" . company-select-previous)
    ("C-j" . company-select-next)
    ;("<tab>" . company-complete-common-or-cycle)
	("<tab>" . company-complete-selection)
    ("<C-return>". yas-expand)
	("<return>" . nil)
	("RET" . nil));
   (:company-search-map
    ("C-j" . company-select-previous)
    ("C-k" . company-select-next)))
  :config
  (leaf company-math
	"Three additional company backends for math latex tags, math unicode symbols
  and latex commands"
	:url "https://github.com/vspinu/company-math"
	:straight t)
  (leaf company-quickhelp
	"Company backend: when idling on a completion candidate the documentation for the candidate will
  pop up after `company-quickhelp-delay' seconds."
	:url "https://github.com/company-mode/company-quickhelp"
	:straight t
	:setq (company-quickhelp-delay . 1.2)
	(company-quickhelp-mode))
  (leaf company-posframe
	"Company frontend which lets allows company to use a child frame as its candidate menu."
	:url "https://github.com/tumashu/company-posframe"
	:straight t
	:after company
	:config
	(setq company-posframe-quickhelp-show-header nil)
	(setq company-posframe-show-indicator nil)
	(setq company-posframe-show-metadata nil)
	(setq company-quickhelp-show-params
		  (list :poshandler #'company-posframe-quickhelp-right-poshandler
				:internal-border-width 1
				:timeout 60
				:internal-border-color (company--face-attribute 'mode-line-inactive :background)
				:no-properties nil
				:poshandler nil))
	;; (company-posframe-mode) ;; Disabled
	))
 
(leaf vertico
  "A performant and minimalistic vertical completion UI. (minibuffer)"
  :url "https://github.com/minad/vertico"
  :straight t
  :require t
  :bind ((:vertico-map
		  ("C-j" . vertico-next)
		  ("C-k" . vertico-previous)))
  :custom
  (vertico-cycle . t)
  (vertico-resize . nil)
  :config (vertico-mode t)
  (leaf vertico-posframe
	"A vertico extension which lets vertico use posframe to show its candidate menu"
	:url "https://github.com/tumashu/vertico-posframe"
	:straight (vertico-posframe :type git :host github :repo "tumashu/vertico-posframe")
	:require t
	:setq (vertico-posframe-poshandler .  #'posframe-poshandler-frame-bottom-center)
	:custom (vertico-posframe-mode . t)))

(leaf orderless
  "Provides an `orderless' completion style (a back-end for completion), that divides the pattern
into space-separated components, and matches candidates that match all of the components in any order."
  :url "https://github.com/oantolin/orderless"
  :straight t
  :custom (completion-styles .`(orderless)))

(leaf yasnippet
  "YASnippet is a template system for emacs which allows you to type an abbreviation and
automatically expand it into function templates."
  :url "https://github.com/joaotavora/yasnippet"
  :straight t
  :setq (yas-snippet-dirs . '("~/.emacs.d/snippets"))
  :config (yas-global-mode))

(leaf consult
  "Consult implements a set of different `consult-<thing>'s"
  :url "https://github.com/minad/consult"
  :straight t
  :config (global-set-key (kbd "C-x b") 'consult-buffer)
  (leaf consult-lsp
	"Consult-lsp leverages lsp-mode's extra information mimicing some of the features of
  `helm-lsp' & `lsp-ivy'"
	:url "https://github.com/gagbo/consult-lsp"
	:straight t))

(leaf lsp-mode
  "The emacs client for language server protocol"
  :url "https://github.com/emacs-lsp/lsp-mode"
  :straight t
  :setq (lsp-inhibit-message . t)
  :setq (lsp-eldoc-render-all . nil)
  :setq (lsp-enable-file-watchers . nil)
  :setq (lsp-highlight-symbol-at-point . nil)
  ;; Uncomment for less noise 
  ;; :setq (lsp-completion-show-detail . nil)
  ;; :setq (lsp-completion-show-kind . nil)
  :setq (lsp-idle-delay . 0.1)
  :setq (lsp-headerline-breadcrumb-mode-enable . t)
  :setq (lsp-signature-function . 'lsp-signature-posframe)
  :hook '((c-mode-hook . lsp)
		  (python-mode-hook . lsp)
		  (java-mode-hook . lsp)
		  (c++-mode-hook . lsp))
  :bind ((:global-map ("M-RET" . lsp-execute-code-action)))
  :config
  (leaf lsp-ui
	"Higher level UI modules for `lsp-mode', like flycheck support and code lenses."
	:url "https://github.com/emacs-lsp/lsp-ui"
	:straight t
	:hook (lsp-mode . lsp-ui-mode)
	:setq (lsp-prefer-flymake . nil)
	:setq (lsp-ui-doc-delay . 5.0)
	:setq (lsp-ui-sideline-enable . nil)
	:setq (lsp-ui-sideline-show-symbol . nil)
	:custom (lsp-ui-doc-position 'bottom)))


(leaf which-key
  "Minor mode for emacs which displays keybindings for your currently entered incomplete
command (a prefix) in a popup."
  :url "https://github.com/justbur/emacs-which-key"
  :straight t
  :setq (which-key-idle-delay . 0.90)
  :setq (which-key-idle-secondary-delay . 0)
  :config (which-key-mode t)
   (leaf which-key-posframe
	 "Displays which-key messages using posframe"
	:straight (which-key-posframe :flavor nil :type git :host github :repo "eeshugerman/which-key-posframe" :branch "patch-1")
	:setq (which-key-posframe-poshandler .  #'posframe-poshandler-frame-bottom-center)
	:setq (which-key-posframe-border-width . 1)
	:config (which-key-posframe-mode t)))

(leaf diff-hl
  "`diff-hl-mode' highlights uncommited changes on the side of the window (using the
fringe, by default), allows you to  jump between the hunks and revert them selectively."
  :url "https://github.com/dgutov/diff-hl"
  :straight t
  :config (global-diff-hl-mode))

(leaf magit
  "A Git user interface with short mnemonic key sequences to increase git workflow"
  :url "https://github.com/magit/magit"
  :straight t)

(leaf projectile
  "Project management and navigation where the definition of a project is just: a folder
containing a special file(`.projectile'). Currently git, mercurial and bazaar repos are considered
projects by default."
  :url "https://github.com/bbatsov/projectile"
  :straight t
  :config (projectile-mode +1))

(leaf treemacs
  "A flexible file tree project explorer"
  :url "https://github.com/Alexander-Miller/treemacs"
  :straight t
  :require t
  :setq ((treemacs-defered-git-apply-delay . 0)
		 (treemacs-file-follow-delay . 2)
		 (treemacs-show-cursor . nil)
		 (treemacs-silent-filewatch . t)
		 (treemacs-silent-refresh . t))
  :setq (treemacs-space-between-root-nodes . nil)
  :bind ((:evil-normal-state-map
		  ("C-<tab>" . treemacs)))
  :init (with-eval-after-load 'treemacs
		  (treemacs-set-width 5)
		  (treemacs-resize-icons 10))
  :config
  (leaf treemacs-evil
	"Evil mode integration for treemacs."
	:url "https://github.com/Alexander-Miller/treemacs"
	:straight t
	:require t)
  (leaf treemacs-magit
	"Hooks into magit so as to artificially produce filewatch events for changes that treemacs
  would otherwise not catch, nameless the commiting and (un)staging of files."
	:url "https://github.com/Alexander-Miller/treemacs"
	:straight t)
  (leaf lsp-treemacs
	"Integration between `lsp-mode' and `treemacs' with tree views for different aspects of your
  code like symbols, references to symbols or diagnostic messages."
	:url "https://github.com/emacs-lsp/lsp-treemacs"
	:straight t))

(leaf embark
  "Provides a contextual menu for Emacs, accss through the `embark-act' command, offering actions
to use on a target determined by the context."
  :url "https://github.com/oantolin/embark"
  :straight t
  :config
  (global-set-key (kbd "C-,") 'embark-act)
  (global-set-key (kbd "C-/") 'embark-bindings))

(leaf marginalia
  "Adds 'marginalia', which are marks or annotations placed at the margin of the page of a book; in 
emacs these take the form of various colorful annotations placed in the margin of the minibuffer for
compleiton candidates."
  :url "https://github.com/minad/marginalia"
  :straight t
  :after vertico
  :custom (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init (consult-lsp-marginalia-mode)
  (marginalia-mode))

(leaf posframe
  "Posframe creates a pop up frame at point; a child-frame connected to its root window's buffer"
  :url "https://github.com/tumashu/posframe"
  :straight t)

(leaf solaire-mode
  "Visually distinguish code-editing windows from sidebars, popups, terminals, etc. It changes
the background of buffers to make them easier to distinguish from other, not-so-important buffers."
  :url "https://github.com/hlissner/emacs-solaire-mode"
  :straight t
  :hook (after-init-hook . solaire-global-mode)
  ;; Disable for the following modes
  :hook (vterm-mode-hook . solaire-mode))

(leaf doom-themes
  "The doom theme meta package"
  :url "https://github.com/doomemacs/themes"
  :straight t
  :config
  (leaf doom-modeline
	"Provides a fancy & fast modeline"
	:url "https://github.com/seagle0128/doom-modeline"
	:straight t
	:hook (after-init-hook)
	:custom
	(doom-modeline-irc . nil)
	(doom-modeline-gnus . nil)
	(doom-modeline-github . nil)
	(doom-modeline-persp-name . nil)
	(doom-modeline-unicode-fallback . t)
	(doom-modeline-enable-word-count . nil)
	:config
	(doom-modeline-init)
	(doom-modeline-mode)))

;; On first run you must first install the all-the-icons fonts with `all-the-icons-install-fonts'
(leaf all-the-icons
  "A utility package to collect various Icon Fonts and propertize them within Emacs. Provides
icons for doom-modeline."
  :url "https://github.com/domtronn/all-the-icons.el"
  :straight t
  :config
  (when (display-graphic-p)
	(require 'all-the-icons nil nil))
  (leaf all-the-icons-dired
	"Dired support for all the icons"
	:url "https://github.com/wyuenho/all-the-icons-dired"
	:straight t
	:hook (dired-mode-hook . all-the-icons-dired-mode))
  (leaf all-the-icons-completion
	"Adds icons to completion candidates using the built in completion metadata functions."
	:url "https://github.com/iyefrat/all-the-icons-completion"
	:straight t
	:config (all-the-icons-completion-marginalia-setup)))
	
(leaf minimap
  "A Sidebar showing a /minimap/ of a buffer."
  :url "https://github.com/emacs-straight/minimap"
  :straight t
  :require t
  :setq ((minimap-window-location . 'right)
		 (minimap-update-delay . 0)
		 (minimap-width-fraction . 0.09)
		 (minimap-minimum-width . 15)))

(leaf nadvice
  "A re-implementation of the functionality of emacs/`nadvice.el'. Used as a last resort to modify
an existing function to execute your code `:before', `:after' or `:around' an existing function."
  :url "https://github.com/emacs-straight/nadvice"
  :straight t)

(leaf vterm
  "A fully-fledged terminal emulator based on the external library (libvterm) loaded as a dynamic
module. Requires CMake and libvterm."
  :url "https://github.com/akermu/emacs-libvterm"
  :straight t
  :require t
  :hook (add-hook 'vterm-mode-hook (lambda () (setq-local global-hl-line-mode nil)))
  :config
  (define-key vterm-mode-map (kbd "C-S-k") 'evil-window-prev)
  (define-key vterm-mode-map (kbd "C-S-j") 'evil-window-next))

;;
;; Custom Functions
;; ================

(defun rc/arrayify (start end quote)
  "Turn strings on newlines into a QUOTEd, comma-separated one-liner."
  (interactive "r\nMQuote: ")
  (setq num-elements (count-words start end))
  (let ((insertion
         (mapconcat
          (lambda (x) (format "%s%s%s" quote x quote))
          (split-string (buffer-substring start end)) ", ")))
    (delete-region start end)
    (insert insertion))
  (print num-elements)
  (evil-yank start end))

(defun rc/evil-yank-advice (orig-fn beg end &rest args)
  (pulse-momentary-highlight-region beg end)
  (apply orig-fn beg end args))
(advice-add 'evil-yank :around 'rc/evil-yank-advice)


(defun rc/backward-kill-word ()
  "Remove all whitespace if the character behind the cursor is whitespace, otherwise remove a word."
  (interactive)
  (if (looking-back "[ \n]")
	  ;; delete horizontal space before us then check to see if we are looking at a new line
	  (progn (delete-horizontal-space 't)
			 (while (looking-back "[ \n]")
			   (backward-delete-char 1)))
	;; otherwise, just do the normal kill word.
	(backward-kill-word 1)))
(global-set-key (kbd "C-<backspace>") 'rc/backward-kill-word)

(defun rc/syntax-color-hex ()
  "Syntax color text of the form [#ff1000] and [#abc] in current
buffer."
  (interactive)
  (font-lock-add-keywords
   nil
   '(("#[[:xdigit:]]\\{3\\}"
      (0 (put-text-property
	  (match-beginning 0)
	  (match-end 0)
	  'face (list :background
		      (let* (
			     (ms (match-string-no-properties 0))
			     (r (substring ms 1 2))
			     (g (substring ms 2 3))
			     (b (substring ms 3 4)))
			(concat "#" r r g g b b))))))
     ("#[[:xdigit:]]\\{6\\}"
      (0 (put-text-property
	  (match-beginning 0)
	  (match-end 0)
	  'face (list :background (match-string-no-properties 0)))))))
  (font-lock-flush)) ;; Source: Xahlee.info

(defun rc/describe-char-at-mouse-click (click-event)
    "`describe-char' at CLICK-EVENT's position.
CLICK-EVENT should be a mouse-click event."
    (interactive "e")
    (run-hooks 'mouse-leave-buffer-hook)
    (let ((pos (cadr (event-start click-event))))
      (describe-char pos)))
;; <d>escribe
(global-set-key (kbd "C-c d <down-mouse-1>")
                #'rc/describe-char-at-mouse-click)

;; Global Bindings
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C-_") 'text-scale-decrease)
(global-set-key (kbd "C-S-k") 'evil-window-prev)
(global-set-key (kbd "C-S-j") 'evil-window-next)

;; Store in register
(define-key evil-normal-state-map (kbd "C-y") 'copy-to-register)
(define-key evil-visual-state-map (kbd "C-y") 'copy-to-register)
;; Dislay Menu to paste from register
(define-key evil-normal-state-map (kbd "C-p") 'consult-register)
(define-key evil-visual-state-map (kbd "C-p") 'consult-register)

(global-set-key (kbd "C-f") 'consult-imenu)

(global-set-key (kbd "C-S-e") 'evil-copy-from-above)
(global-set-key (kbd "C-e") 'evil-copy-from-below)

;(load-file "~/.emacs.d/deadline-theme.el")
;(consult-theme 'deadline)
(consult-theme 'doom-zenburn)
