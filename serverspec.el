;;; serverspec.el --- Serverspec minor mode
;; -*- Mode: Emacs-Lisp -*-

;; Copyright (C) 2014 by 101000code/101000LAB

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

;; Version: 0.0.7
;; Author: k1LoW (Kenichirou Oyama), <k1lowxb [at] gmail [dot] com> <k1low [at] 101000lab [dot] org>
;; URL: http://101000lab.org
;; Package-Requires: ((dash "2.6.0") (s "1.9.0") (f "0.16.2") (helm "1.6.1"))

;;; Install
;; Put this file into load-path'ed directory, and byte compile it if
;; desired.  And put the following expression into your ~/.emacs.
;;
;; (require 'serverspec)
;;
;; If you use default key map, Put the following expression into your ~/.emacs.
;;
;; (serverspec::set-default-keymap)

;;; Commentary:

;;; Commands:
;;
;; Below are complete command list:
;;
;;  `serverspec'
;;    Serverspec minor mode.
;;  `serverspec::find-spec-files'
;;    Find spec files.
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;
;;  `serverspec::dir-search-limit'
;;    Search limit
;;    default = 5

;;; Code:

;;require
(require 'dash)
(require 's)
(require 'f)
(require 'cl)
(require 'helm-config)
(require 'easy-mmode)

(defgroup serverspec nil
  "Serverspec minor mode"
  :group 'languages
  :prefix "serverspec::")

(defcustom serverspec::dir-search-limit 5
  "Search limit"
  :type 'integer
  :group 'serverspec)

;;;###autoload
(defvar serverspec::key-map
  (make-sparse-keymap)
  "Keymap for Serverspec.")

(defvar serverspec::spec-path nil
  "Serverspec spec directory path.")

(defvar serverspec::hook nil
  "Hook.")

;;;###autoload
(define-minor-mode serverspec
  "Serverspec minor mode."
  :lighter " Serverspec"
  :group 'serverspec
  (if serverspec
      (progn
        (setq minor-mode-map-alist
              (cons (cons 'serverspec serverspec::key-map)
                    minor-mode-map-alist))
        (serverspec::dict-initialize)
        (run-hooks 'serverspec::hook))
    nil))

(defun serverspec::set-default-keymap ()
  "Set default key-map."
  (setq serverspec::key-map
        (let ((map (make-sparse-keymap)))
          (define-key map (kbd "C-c s") 'serverspec::find-spec-files)
          map)))

(defun serverspec::update-spec-path ()
  "Update serverspec::spec-path"
  (let ((spec-path (serverspec::find-spec-path)))
    (unless (not spec-path)
      (setq serverspec::spec-path spec-path))
    (if serverspec::spec-path
        t
      nil)))

(defun serverspec::find-spec-path ()
  "Find spec directory."
  (let ((current-dir (f-expand default-directory)))
    (loop with count = 0
          until (f-exists? (f-join current-dir "spec_helper.rb"))
          ;; Return nil if outside the value of
          if (= count serverspec::dir-search-limit)
          do (return nil)
          ;; Or search upper directories.
          else
          do (incf count)
          (unless (f-root? current-dir)
            (setq current-dir (f-dirname current-dir)))
          finally return current-dir)))

(defun serverspec::list-spec-files ()
  (if (serverspec::update-spec-path)
      (-map
       (lambda (file) (f-relative file serverspec::spec-path))
       (f-files serverspec::spec-path (lambda (file) (s-matches? "_spec.rb" (f-long file))) t))
    nil))

(defun serverspec::helm-spec-files-display-to-real (file)
  (f-expand file serverspec::spec-path))

;;;###autoload
(defvar serverspec::helm-spec-files-source
  '((name . "Spec files")
    (candidates . serverspec::list-spec-files)
    (display-to-real . serverspec::helm-spec-files-display-to-real)
    (action . find-file))
    "Spec file helm source.")

;;;###autoload
(defun serverspec::find-spec-files ()
  "Find spec files."
  (interactive)
  (helm-other-buffer `(serverspec::helm-spec-files-source) "*helm spec*"))

(defconst serverspec::dir (file-name-directory (or (buffer-file-name)
                                                            load-file-name)))

;;;###autoload
(defun serverspec::snippets-initialize ()
  (let ((snip-dir (expand-file-name "snippets" serverspec::dir)))
    (add-to-list 'yas-snippet-dirs snip-dir t)
    (yas-load-directory snip-dir)))

;;;###autoload
(eval-after-load 'yasnippet
  '(serverspec::snippets-initialize))

;;;###autoload
(defun serverspec::dict-initialize ()
  (let ((dict-dir (expand-file-name "dict" serverspec::dir)))
    (add-to-list 'ac-dictionary-files (f-join dict-dir "serverspec") t)))

(provide 'serverspec)

;;; end
;;; serverspec.el ends here
