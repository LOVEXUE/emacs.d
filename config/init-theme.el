;;; init-themes.el --- Defaults for themes -*- lexical-binding: t -*-
;; Author:  Gaeric
;; URL: https://github.com/Gaeric/emacs.d
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Code:

(require 'doom-themes)
(require 'doom-themes-ext-org)
(require 'doom-themes-ext-neotree)
(require 'doom-themes-ext-treemacs)

;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled

;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
(load-theme 'doom-vibrant t)
;; (load-theme 'doom-one-light t)          ;theme for light

;; Enable flashing mode-line on errors
;; (doom-themes-visual-bell-config)

;; Enable custom neotree theme (all-the-icons must be installed!)
(doom-themes-neotree-config)
;; or for treemacs users
(setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
(doom-themes-treemacs-config)

;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

(provide 'init-theme)
