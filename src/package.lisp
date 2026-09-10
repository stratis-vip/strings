;;; file STRINGS:src/package.lisp -- exports from package strings
;;; 
;;; Code: 
;;; 

(defpackage :strings
 (:use :cl :lists)
 (:export
  :take
  :drop
  :split-by
  :trim
  :trim-left
  :trim-right

  :string->atonic 
  :char-list-p

  :replace-multi-word-tokens
   )) 

;;; STRINGS:src/package.lisp ends here
