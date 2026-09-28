;;; file-read-only-default.el -*- lexical-binding: t -*-

;; Copyright (C) 2026 Free Software Foundation, Inc.

;; Author: Adam Klingenberger
;; Maintainer: Adam Klingenberger
;; Created: 2026
;; Version: 0.2.0
;; Package-Requires: TBD
;; URL: https://github.com/AdamKlingenberger/file-read-only-default
;; Keywords: emacs, read-only-mode

;; This file is part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
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

;; file-read-only-default allows configuring directories and file names
;; which should open read-only in Emacs.
;;
;; Externally maintained code, such as packages hosted on Elpa/Melpa,
;; are usually not desirable to accidentally modify when visiting in a
;; buffer. Therefore, it is helpful if files stored in those directories
;; open read-only by default. This small package provides a simple way
;; to do this through a customizable variable.

;;; Code:

(defgroup file-read-only-default ()
  "Minor mode to set `read-only-mode' when visiting files in user-defined locations."
  :prefix "file-read-only-default-"
  :group 'file)


;;; User options ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defcustom file-read-only-default-pattern-list nil
  "List of user-defined patterns to match target file path for `find-file-hook'.
If the target file path matches one of the patterns, then it will be opened
as read-only.

This option can be used to prevent accidental edit of files visited, for
example, from the Help buffer."
  :type '(repeat :tag "Read-only file pattern list"
		 (string :tag "Read-only file pattern")))

(defun file-read-only-default-default-p (pattern file)
  "Default predicate used by `file-read-only-default-predicate'."
  (string-prefix-p (expand-file-name pattern) file))

(defcustom file-read-only-default-predicate #'file-read-only-default-default-p
  "Function which is invoked to test each pattern in
`file-read-only-default-pattern-list'."
  :type 'function
  :risky t)

;;; Main methods ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun file-read-only-default-set ()
  "Enable `read-only-mode' if `buffer-file-name' matches a pattern in
`file-read-only-default-pattern-list'.
Returns non-nil if `read-only-mode' is enabled, nil otherwise."
  (when buffer-file-name
    (let ((patterns file-read-only-default-pattern-list) (match) (pattern))
      (while (and (not match) patterns)
	(setq pattern (pop patterns))
	(if (and pattern (funcall file-read-only-default-predicate pattern buffer-file-name))
	    (setq match t)))
      (when match
	(read-only-mode)))))

;;; Mode definition ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun file-read-only-default--enable-mode ()
  "Enable `file-read-only-default-mode'."
  (add-hook 'find-file-hook #'file-read-only-default-set))

(defun file-read-only-default--disable-mode ()
  "Disable `file-read-only-default-mode'."
  (remove-hook 'find-file-hook #'file-read-only-default-set))

;;;###autoload
(define-minor-mode file-read-only-default-mode
  "Default to `read-only-mode' when visiting files in user-defined locations."
  :global t
  (if file-read-only-default-mode
      (file-read-only-default--enable-mode)
    (file-read-only-default--disable-mode)))


(provide 'file-read-only-default)
;;; file-read-only-default.el ends here
