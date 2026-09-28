;; -*- lexical-binding: t; -*-

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
