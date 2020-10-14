;; init-org.el --- org init -*- coding: utf-8; lexical-binding: t; -*-
;; Author:  Gaeric
;; URL: https://github.com/Gaeric/emacs.d
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(when (maybe-require-package  'org-bullets)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(when (maybe-require-package 'org-pomodoro)
  (setq org-pomodoro-keep-killed-pomodoro-time t)
  (setq org-pomodoro-long-break-frequency 3)
  (setq org-pomodoro-format "Pomodoro %s")
  (with-eval-after-load 'org-agenda
    (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro)
    (define-key org-agenda-mode-map (kbd "Z") 'org-agenda)))


(with-eval-after-load 'org
  ;; ----------------------------------------------------------------------
  ;; 配置org-emphasis，优化org-mode中文体验
  ;; ----------------------------------------------------------------------
  (setq org-emphasis-regexp-components
        ;; add multibyte char at pre and post For chinese
        '("-[:space:][:multibyte:]('\"{" "-[:space:][:multibyte:].,:!?;'\")}\\[" "[:space:]" "." 1))
  (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
  ;; (org-element-update-syntax)
  ;; Non-nil means interpret "_" and "^" for display.
  ;; 适用于导出
  (setq org-export-with-sub-superscripts '{})
  ;; 适用于org-mode中渲染
  ;; (setq org-use-sub-superscripts '{})
  ;; ----------------------------------------------------------------------
  ;; 配置org-mode 标题样式
  ;; ----------------------------------------------------------------------
  

  ;; 导出的源代码内容使用单独的css文件控制样式
  (setq org-html-htmlize-output-type 'css)
  ;; 不生成默认的css及javascript内容
  (setq org-html-head-include-default-style nil)
  (setq org-html-head-include-scripts nil)
  (setq org-publish-timestamp-directory
        (convert-standard-filename "~/.emacs.d/.org-timestamps/"))

  (setq org-publish-project-alist
        '(
          ;; ... add all the components here (see below)...
          ("pre_pub"
           :base-directory "~/org/blog" ;; org文件的目录
           :base-extension "png\\|org"
           :publishing-directory "~/project_py/org_blog/static/static_html" ;导出目录
           :publishing-function org-html-publish-to-html
           ;; :auto-sitemap t
           )))

  ;; org-src-edit时打开新窗口，完成后恢复布局
  (setq org-src-window-setup 'other-window)

  ;; TODO: 待处理的事务
  ;; STARTED: 事务进行中
  ;; SUSPEND: 事务挂起
  ;; CANCELLED: 已弃置处理的事务
  ;; DONE: 已处理完成的事务
  (setq org-todo-keywords
        '((sequence
           "TODO(t)" "STARTED(s!)" "SUSPEND(S@)" "|" "DONE(d@)" "CANCELLED(c@/@)")))

  (setq org-clock-in-switch-to-state "STARTED")
  (setq org-clock-out-switch-to-state "SUSPEND")
  
  (setq org-capture-templates
        '(("t" "Todo" entry
           (file+headline "~/org/gtd.org" "Workspace")
           "* TODO [#B] %?\n  %i\n")
          ("n" "notes" entry
           (file+headline "~/org/inbox.org" "notes")
           "* %?\n  %i\n %U")
          ("b" "Breakpoint" entry (clock)
           "* TODO %? :BreakPoint:\n  %U\n  %i")
          ("e" "Excerpt" entry
           (file+headline "~/org/inbox.org" "Excerpt")
           "* %?"))))

;; -------------------------------------------------------------------
;; for blog static file
;; -------------------------------------------------------------------
(defvar gaeric-static-file-dir "")
(defun gaeric-static-blog-change-link (path desc backend)
  "change link for static file"
  (if (eq backend 'html)
      (unless desc
        (message "abspath is %s" (expand-file-name path))
        (if (file-exists-p path)
            (let* ((file-abs (expand-file-name path))
                   (file-md5 (substring-no-properties (md5 file-abs) 0 8))
                   (file-new (concat (file-name-base file-abs) "_" file-md5 "." (file-name-extension file-abs))))
              (if (file-exists-p (concat gaeric-static-file-dir file-new))
                  (message "Skipping unmodified file %s" file-abs)
                (copy-file file-abs file-new))
              (format "<img src=\"%s\" alt=\"%s\"/>" file-new file-new))))))

;; /usr/share/emacs/28.0.50/lisp/org/ox-html.el
;; 3117:      ((org-export-custom-protocol-maybe link desc 'html))


(with-eval-after-load 'org-agenda
  (setq org-agenda-span 'day)
  (setq org-agenda-custom-commands
        '(("w" . "任务安排")
          ("wa" "重要且紧急的任务" tags-todo "+PRIORITY=\"A\"")
          ("wb" "重要且不紧急的任务" tags-todo "-Weekly-Monthly-Daily+PRIORITY=\"B\"")
          ("wc" "不重要且紧急的任务" tags-todo "+PRIORITY=\"C\"")
          ;;("p" . "项目安排")
          ("W" "Weekly Review")))

  (setq org-agenda-files
        (quote ("~/org/inbox.org" "~/org/gtd.org"))))

;; `org-capture' is global
(gaeric-space-leader-def
  "aoc" 'org-capture
  "aoo" 'org-agenda
  "aoa" 'org-agenda-list
  )

(gaeric-comma-leader-def
  :keymaps 'org-mode-map
  "op" 'org-pomodoro
  "cp" 'org-previous-visible-heading
  "cn" 'org-next-visible-heading
  "cf" 'org-forward-heading-same-level
  "cb" 'org-backward-heading-same-level
  "ns" 'org-narrow-to-subtree
  "nb" 'org-narrow-to-block
  "ne" 'org-narrow-to-element
  "'"  'org-edit-special)

(gaeric-comma-leader-def
  :keymaps 'org-src-mode-map
  "c'" 'org-edit-src-exit
  "ck" 'org-edit-src-abort)

(provide 'init-org)
