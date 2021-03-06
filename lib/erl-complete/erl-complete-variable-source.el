;; Copyright 2012 Thomas Järvstrand <tjarvstrand@gmail.com>
;;
;; This file is part of EDTS.
;;
;; EDTS is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; EDTS is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with EDTS. If not, see <http://www.gnu.org/licenses/>.
;;
;; auto-complete source for erlang variables.

(require 'auto-complete)
(require 'ferl)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Source

(defvar erl-complete-variable-source
  '((candidates . erl-complete-variable-candidates)
    (document   . nil)
    (symbol     . "v")
    (requires   . nil)
    (limit      . nil)
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Candidate functions

(defun erl-complete-variable-candidates ()
  (case (erl-complete-point-inside-quotes)
    ('double-quoted nil) ; Don't complete inside strings
    ('single-quoted nil) ; No single-quoted variables
    ('none          (erl-complete-normal-variable-candidates))))

(defun erl-complete-normal-variable-candidates ()
  "Generates the auto-complete candidate list for variables. Matches variables
mentioned in current function, before current point."
  (when (erl-complete-variable-p)
    (save-excursion
      (let ((old-point  (point))
            (candidates ()))
        (ferl-beginning-of-function)
        (while (and (re-search-forward erlang-variable-regexp old-point t)
                    (< (match-end 0) old-point))
          (add-to-list 'candidates (thing-at-point 'symbol)))
        candidates))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Conditions
;;

(defun erl-complete-variable-p ()
  "Returns non-nil if the current `ac-prefix' can be completed with an
variable."
  (let ((case-fold-search nil)
        (preceding        (erl-complete-term-preceding-char)))
    (and
     (not (equal ?? preceding))
     (not (equal ?# preceding))
     (string-match erlang-variable-regexp ac-prefix))))

(provide 'erl-complete-variable-source)