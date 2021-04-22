;;; ob-hide-markers.el --- Hide or-babel source code markers.  -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Arthur Miller

;; Author: Arthur Miller <arthur.miller@live.com>
;; Keywords: convenience, outlines, tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; A minor mode to help reduce clutter in org-babel code blocks by
;; hiding/unhiding markers for source code blocks in org-mode.
;;
;; To hide all markers turn on org-hbm-mode by
;;
;;          `M-x org-hbm-mode.'
;;
;; To turn it off execute same command.
;;
;; The mode provides two additional interactive commands.
;;
;; Use `hbm-refresh' if you add new code blocks, copy-paste etc.
;;
;; Alternatively it is possible to turn on/off markers for an individual source
;; code by executing `M-x hbm-toggle-current-block'. It does not require
;; org-hbm-mode to be on, but you will have to call it again to make markers
;; visible again.
;;
;; It is possible to somewhat control the appereance of org-file by customizing
;; the `orh-hbm-hide-marker-line' variable. When this variable is nil, markers
;; will be invisible but the newline character will be left visible resulting in
;; somewhat "fluffier" appereance. Whan the value is set to `t' even newline
;; character will be hidden resulting in more dense and compact code. That might
;; not be for everyone, so set it to your own preference. It is `nil' by
;; default.

;;; Code:
(defcustom org-babel-hide-markers-line nil
  "If value of this variable is `t', org-hbm mode vill hide also line on which
  source code block markers are, otherwise only markers are hidden leaving an
  empty line."
  :group 'org-babel
  :tag "Org Babel Hide Source Block Markers Line")

(defvar hbm--mode-on nil)
(defvar hbm--marker-re "^[ \t]*#\\+\\(begin\\|end\\)_src")

(defun hbm--update-line (visible)
  (let ((beg (if org-babel-hide-markers-line
                 (1- (line-beginning-position))
               (line-beginning-position)))
        (end (line-end-position)))
  (put-text-property beg end 'invisible visible)))

(defun hbm--update-markers (visible)
  (save-excursion
    (goto-char (point-min))
    (with-silent-modifications
      (while (re-search-forward hbm--marker-re nil t)
        (hbm--update-line visible))
      (setq hbm--mode-on visible))))

;;;###autoload
(defun org-babel-refresh-markers ()
  (interactive)
  (unless org-babel-hide-markers-mode
    (error "Org-hide-babel-markers mode is not enabled."))
  (font-lock-ensure)
  (hbm--update-markers t))

;;;###autoload
(define-minor-mode org-babel-hide-markers-mode
  "Hide/show babel source code blocks on demand."
  :global nil :lighter " OB Hmm"
  (unless (derived-mode-p 'org-mode)
    (error "Not in org-mode."))
  (make-local-variable 'hbm--mode-on)
  (cond (org-babel-hide-markers-mode
         (unless hbm--mode-on
           (font-lock-ensure)
           (hbm--update-markers t)))
        (t
         (when hbm--mode-on
           (hbm--update-markers nil)))))

(provide 'ob-hide-markers)

;;; ob-hide-markers.el ends here
