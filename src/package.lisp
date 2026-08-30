;;; file STRINGS:src/package.lisp -- exports from package strings
;;; 
;;; Code: 
;;; 

(defpackage :strings
 (:use :cl :lists)
 (:export
  :sub-string
  :take
  :drop
  :split-by
  :trim
  :trim-left
  :trim-right
  :merge-comparison-words

  :string->atonic 
  :char-list-p

  :replace-multi-word-tokens
   )) 

;;; STRINGS:src/package.lisp ends here
