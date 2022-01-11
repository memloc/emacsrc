;;  
(unless (>= emacs-major-version 24)
  (error "The deadline-theme requires Emacs 24 or later!"))

(deftheme deadline
  "The theme for sleepless nights")

;; Customization Options {{{
(defgroup deadline nil
  "Deadline theme options.
The theme has to be reloaded after changing anything in this group."
  :group 'faces)

(defcustom deadline-distinct-fringe-background nil
  "Make the fringe background different from the normal background color.
Also affects both the 'linum-mode' and 'solaire-mode' background."
  :type 'boolean
  :group 'deadline)

(defcustom deadline-use-variable-pitch nil
  "Use variable pitch face for some headings and titles."
  :type 'boolean
  :group 'deadline)

(defcustom deadline-height-minus-1 0.8
  "Font size -1."
  :type 'number
  :group 'deadline)

(defcustom deadline-height-plus-1 1.1
  "Font size +1."
  :type 'number
  :group 'deadline)

(defcustom deadline-height-plus-2 1.15
  "Font size +2."
  :type 'number
  :group 'deadline)

(defcustom deadline-height-plus-3 1.2
  "Font size +3."
  :type 'number
  :group 'deadline)

(defcustom deadline-height-plus-4 1.3
  "Font size +4."
  :type 'number
  :group 'deadline)

;; Primary Colors

(defcustom deadline-background "#2a2734"
  "Adaptive colors - background"
  :type 'string
  :group 'deadline)

(defcustom deadline-background-highlight "#433C5A"
  "Adaptive colors - background highlight"
  :type 'string
  :group 'deadline)

(defcustom deadline-region "#2A2344"
  "Adaptive colors - region"
  :type 'string
  :group 'deadline)

(defcustom deadline-darker-background "#2A2637"
  "Adaptive colors - darker background"
  :type 'string
  :group 'deadline)

(defcustom deadline-foreground "#ffcc99"
  "Adaptive colors - foreground"
  :type 'string
  :group 'deadline)

(defcustom deadline-typename "#FFE0D1"
  "Adaptive color - type name"
  :type 'string
  :group 'deadline)

;(defcustom deadline-identifier "")

(defcustom deadline-strings "#ffb870"
  "Adaptive colors - strings"
  :type 'string
  :group 'deadline)

(defcustom deadline-line-number "#4F4D57"
  "Adaptive colors - line number"
  :type 'string
  :group 'deadline)

(defcustom deadline-constant "#E8FFFD"
  "Adaptive colors - constants"
  :type 'string
  :group 'deadline)

(defcustom deadline-links "#FF9658"
  "Adaptive colors -links"
  :type 'string
  :group 'deadline)

(defcustom deadline-keyword "#83E3CE"
  "Adaptive colors - keyword"
  :type 'string
  :group 'deadline)

(defcustom deadline-function "#E8FFFD"
  "Adaptive colors - function"
  :type 'string
  :group 'deadline)

(defcustom deadline-comments "#6c6783"
  "Adaptive colors - comments"
  :type 'string
  :group 'deadline)

(defcustom deadline-highlight-line "#302D3B"
  "Adaptive colors - line highlight"
  :type 'string
  :group 'deadline)

(defcustom deadline-cursor "#956e50"
  "Adaptive colors - cursor"
  :type 'string
  :group 'deadline)


;; Variables {{{
(let* (;; Variable pitch
	   (deadline-pitch (if deadline-use-variable-pitch
						   'variable-pitch
						 'default))
	   ;; }}}

	   ;; Colors {{{
	   (deadline-input-fg           "#FF9F9A")
	   (deadline-purple-epic        "#a335ee")
	   (deadline-magenta            "#ed92f8")
	   (deadline-holy-light         "#FFF3B1")

	   (deadline-background-overlay "#464050")

	   ;; Distinct fringe
	   (deadline-fringe-bg (if deadline-distinct-fringe-background
							   deadline-darker-background
							 deadline-background)))
  ;; }}}

  ;; custom-theme-set-faces {{{
  (custom-theme-set-faces
   'deadline
   ;; }}}

   ;; font lock for syntax highlighting {{{
   `(font-lock-builtin-face
	 ((t (:foreground ,deadline-input-fg  ; identifier
					  :weight normal))))
   `(font-lock-keyword-face
	 ((t (:foreground ,deadline-keyword
					  :weight normal))))
   `(font-lock-type-face
	 ((t (:foreground ,deadline-typename ; typename
					  :italic t))))
   `(font-lock-variable-name-face
	 ((t (:foreground ,deadline-foreground
					  :weight normal))))
   `(font-lock-constant-face 
	 ((t (:foreground ,deadline-constant))))
   `(font-lock-function-name-face
	 ((t (:foreground ,deadline-function
					  :weight bold))))
   `(font-lock-string-face
	 ((t (:foreground ,deadline-strings))))
   `(font-lock-comment-face
	 ((t (:foreground ,deadline-comments ; comments
					  :italic t))))
   `(font-lock-comment-delimiter-face
     ((t (:foreground ,deadline-comments
					  :weight bold))))
   ;; }}}
   
   ;;; general coloring {{{
   `(default
	 ((t (:foreground ,deadline-foreground
					  :background ,deadline-background))))
   `(link
	 ((t (:foreground ,deadline-links
					  :underline t))))
   `(cursor
	 ((t (:foreground ,deadline-cursor
					  :background ,deadline-cursor))))
   `(fringe
	 ((t (:foreground ,deadline-background
					  :background ,deadline-background))))
   `(highlight
	 ((t (:foreground ,deadline-foreground
					  :background ,deadline-highlight-line))))
   `(region
	 ((t (:background ,deadline-region))))

   `(vertical-border
	 ((t (:foreground ,deadline-background-highlight))))

   `(minibuffer-prompt
	 ((t (:foreground, deadline-purple-epic))))

   `(tooltip
	 ((t (:foreground, deadline-foreground
					   :background ,deadline-background))))
   ;; }}}

   ;; hl-line-mode {{{
   `(hl-line
	 ((t (:background ,deadline-highlight-line))))

   `(hl-line-face
	 ((t (:background ,deadline-highlight-line
					  :foreground ,deadline-magenta))))
   ;; }}}

   ;; linum-mode
   `(linum
	 ((t (:foreground ,deadline-foreground
					  :background ,deadline-fringe-bg
					  :inherit default
					  :underline nil))))
   ;; }}}

   ;; line-number (>= Emacs26) {{{
   `(line-number
	 ((t (:foreground ,deadline-line-number
					   :background ,deadline-fringe-bg
					   :inherit default
					   :underline nil))))
   `(line-number-current-line
	 ((t (:foreground ,deadline-function
					  :background ,deadline-fringe-bg
					  :inherit default
					  :underline nil
					  :weight bold))))
   ;; }}}

   ;; show-paren {{{
   `(show-paren-match
	 ((t (:foreground ,deadline-function
					  :background ,deadline-background
					  :underline t
					  :weight bold))))
   ;; }}}

   ;; solaire-mode
   `(solaire-default-face
	 ((t (:foreground ,deadline-foreground
					  :background ,deadline-darker-background
					  :inherit default
					  :underline nil))))
   `(solaire-fringe-face
	 ((t (:foreground ,deadline-foreground
					  :background ,deadline-darker-background
					  :inherit default
					  :underline nil))))
   ;; }}}

   ;; which-key {{{
   `(which-key-group-description-face
	 ((t (:foreground ,deadline-input-fg))))
   `(which-key-key-face
	 ((t (:foreground ,deadline-foreground))))
   `(which-key-command-description-face
	 ((t (:foreground ,deadline-typename))))
   ;; }}}

   ;; vterm {{{
   `(vterm-color-blue
	 ((t (:foreground ,deadline-keyword))))
   ;; }}}

   ;; mode-line and powerline modeline {{{
   `(mode-line-buffer-id
	 ((t (:foreground ,deadline-foreground
					  :weight bold))))
   `(mode-line
	 ((t (:inverse-video unspecified
						 :underline unspecified
						 :foreground ,deadline-foreground
						 :background ,deadline-background-highlight
						 :box (:color ,deadline-background-highlight
									  :line-width 1)))))
   `(mode-line-highlight
	 ((t (:box nil))))

   `(mode-line-inactive
	 ((t (:inverse-video unspecified
						 :underline unspecified
						 :foreground ,deadline-foreground
						 :background ,deadline-background
						 :box (:color ,deadline-background
									  :line-width 1)))))
   `(doom-modeline-lsp-success
	 ((t (:inherit success
				   :foreground-color ,deadline-purple-epic))))
   ;; }}}

   ;; evil-search-highlight-persist {{{
   `(evil-search-highlight-persist-highlight-face
	 ((t (:inherit region))))
   ;; }}}

   ;; orderless (search match) {{{
   `(orderless-match-face-0
	 ((t (:foreground ,deadline-magenta))))
   ;; }}}

   ;; lsp {{{
   `(lsp-ui-doc-highlight-hover
	 ((t (:foreground ,deadline-holy-light))))
   ;; }}}
   )
)
  
;;;###autoload
(when (and (boundp 'custom-theme-load-path) load-file-name)
  (add-to-list 'custom-theme-load-path
			   (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'deadline)
