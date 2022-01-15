;;; org-babel-hide-markers.el --- Hide org-babel source code markers  -*- lexical-binding: t; -*-

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

;; Author: Arthur Miller
;; Version: 0.0.1
;; Keywords: tools convenience
;; Package-Requires: ((emacs "25.1"))
;; URL: https://github.com/amno1/org-babel-hide-markers-mode

;;; Commentary:

;; A minor mode to help reduce clutter in org-babel code blocks by
;; hiding/unhiding markers for source code blocks in org-mode.
;;
;; To hide all markers turn on org-hbm-mode by
;;
;;          `M-x org-babel-hide-markers-mode.'
;;
;; To turn it off execute the same command.

;;; Issues

;; It can be tricky to enter src_blocks when this mode is enabled, since it
;; works on very "wide" regex, (check the marker regex). You might need to
;; turn-off/turn-on the mode, if you are typing them manually.

;;; Code:
(defgroup org-babel-hide-markers nil
  "Hide babel source code markers in org-mode."
  :prefix "org-babel-hide-markers-"
  :group 'org-babel)

(defcustom org-babel-hide-markers-line nil
  "Whether the resulting empty line after hiding marker will also be hidden.

If value of this variable is 't, even the resulting empty line will be
hidden, otherwise only the markers themselves are hidden leaving an empty line."
  :group 'org-babel-hide-markers
  :type 'boolean)

(defvar org-babel-hide-markers--re "^[ \t]*#\\+\\(begin\\|end\\)_src"
  "Regex used to recognize source block markers.")

(defun org-babel-hide-markers--update-line (visibility)
  "Set the invisible property of a line to VISIBILITY."
  (let ((beg (if org-babel-hide-markers-line
                 (1- (line-beginning-position))
               (line-beginning-position)))
        (end (line-end-position)))
  (put-text-property beg end 'invisible visibility)))

(defun org-babel-hide-markers--update-markers (visibility)
  "Update invisible property to VISIBILITY for markers in the current buffer."
  (save-excursion
    (goto-char (point-min))
    (with-silent-modifications
      (while (re-search-forward org-babel-hide-markers--re nil t)
        (org-babel-hide-markers--update-line visibility)))))

;;;###autoload
(define-minor-mode org-babel-hide-markers-mode
  "Hide/show babel source code blocks on demand."
  :global nil :lighter " OB Hmm"
  (unless (derived-mode-p 'org-mode)
    (error "Not in org-mode"))
  (cond (org-babel-hide-markers-mode
         (org-babel-hide-markers--update-markers nil))
        (t (font-lock-ensure)
           (org-babel-hide-markers--update-markers t))))

(provide 'org-babel-hide-markers)

;;; org-babel-hide-markers.el ends here
