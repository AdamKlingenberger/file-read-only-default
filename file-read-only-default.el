;;; file-read-only-default.el -*- lexical-binding: t -*-

;; Copyright (C) 2026 Free Software Foundation, Inc.

;; Author: Adam Klingenberger
;; Maintainer: Adam Klingenberger
;; Created: 2026
;; Version: 0.1.0
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

;; Open file as read-only depending on location or name
(defcustom read-only-file-pattern-list nil
  "List of user-defined patterns to match target file path for `find-file-hook'.
If the target file path matches one of the patterns, then it will be opened
as read-only.

This option can be used to prevent accidental edit of files visited, for
example, from the Help buffer."
  :type '(repeat :tag "Read-only file pattern list"
		 (directory :tag "Read-only file pattern"))
  :group 'my)

(defun file-read-only-default ()
  (when buffer-file-name
    (let* ((patterns read-only-file-pattern-list)
	   (match nil)
	   (pattern nil))
      (while (and (not match) patterns)
	(setq pattern (pop patterns))
	(if (string-match-p (expand-file-name pattern) buffer-file-name)
	    (progn (read-only-mode)
		   (setq match t)))))))

(provide 'file-read-only-default)
