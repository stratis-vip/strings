;;; STRINGS:tests/strings-tests.lisp
;;;
;;; Code:
;;;

(in-package :strings/tests)

(defsuite strings)
(in-suite strings)

(test take-tests
  ;;wrong variables
  (raise-error (take 34 1) simple-type-error)
  (raise-error (take "alfa" '()) simple-type-error)

  ;;negative n
  (raise-error (take "alfa" -1) simple-type-error)

  ;; n = 0 returns an empty string
  (check (string= "" (take "alfa" 0 )))
  (check (string= "" (take "" 0)))

  ;; n > length
  (check (string= "alfa" (take "alfa" 14)))

  ;; n=> length
  (check (string= "alfa" (take "alfa" 4)))
  (check (string= "alf" (take "alfa" 3))))

(test drop-tests
  ;;wrong variables
  (raise-error (drop 34 1) simple-type-error)
  (raise-error (drop "alfa" '()) simple-type-error)

  ;;negative n
  (raise-error (drop "alfa" -1) simple-type-error)

  ;; n = 0 returns the same string
  (check (string= "alfa" (drop "alfa" 0 )))
  (check (string= "" (drop "" 0)))

  ;; n > length
  (check (string= "" (drop "alfa" 14)))

  ;; n=> length
  (check (string= "" (drop "alfa" 4)))
  (check (string= "a" (drop "alfa" 3))))

(test char-list-p
  ;;string is not a list of char
  (check-not (char-list-p "alfa"))

  ;;invalid inputs
  (check-not (char-list-p '(1 2 3)))
  (check-not (char-list-p 35))
  (check-not (char-list-p '(#\Tab #\Space 23)))

  (check (char-list-p nil))
  (check (char-list-p '(#\Tab #\Space)))
  )

(test split-by-tests
  ;;wrong variables
  (raise-error (split-by 34) simple-type-error)
  (raise-error (split-by "alfa bita" :separator 34) simple-type-error)

  ;;empty separator
  (raise-error (split-by "alfa bita gama" :separator '()) simple-error)

  ;;happy end
  (check (equal '("alfa" "bita" "gama") (split-by "alfa bita gama")))

  ;; spaces in front
  (check (equal '("alfa" "bita" "gama") (split-by "    alfa bita gama")))

  ;; spaces in fornt and  at the end
  (check (equal '("alfa" "bita" "gama") (split-by "    alfa bita gama     ")))
  
  ;; spaces between words
  (check (equal '("alfa" "bita" "gama") (split-by "    alfa     bita      gama    ")))

   ;; spaces between words with custom separator 
  (check (equal '("alfa" "bita" "gama") (split-by "  -  alfa-  -  - bita-     - gama-   -" :separator '(#\Space #\-))))

  ;;empty string
  (check-not (split-by ""))
  )

(test trim-left-tests
  ;;wrong variables
  (raise-error (trim-left 34) simple-type-error)
  (raise-error (trim-left "alfa bita" :trim-chars  34) simple-type-error)

  ;;empty separator
  (raise-error (trim-left "alfa bita gama" :trim-chars '()) simple-error)

  ;;happy end
  (check (string= "alfa" (trim-left "   alfa")))
  (check (string= "" (trim-left "")))
  (check (string= "alfa" (trim-left " - 0 -  0alfa" :trim-chars '(#\Space #\- #\0))))
  )

(test trim-right-tests
  ;;wrong variables
  (raise-error (trim-right 34) simple-type-error)
  (raise-error (trim-right "alfa bita" :trim-chars  34) simple-type-error)

  ;;empty separator
  (raise-error (trim-right "alfa bita gama" :trim-chars '()) simple-error)

  ;;happy end
  (check (string= "alfa" (trim-right "alfa   ")))
  (check (string= "" (trim-right "")))
  (check (string= "alfa" (trim-right "alfa - 0 -  0 " :trim-chars '(#\Space #\- #\0))))
  )


(test trim-tests
  ;;wrong variables
  (raise-error (trim 34) simple-type-error)
  (raise-error (trim "alfa bita" :trim-chars  34) simple-type-error)

  ;;empty separator
  (raise-error (trim "alfa bita gama" :trim-chars '()) simple-error)

  ;;happy end
  (check (string= "alfa" (trim "    alfa   ")))
  (check (string= "" (trim "")))
  (check (string= "alfa" (trim "---000   000---alfa - 0 -  0 " :trim-chars '(#\Space #\- #\0))))
  )

(test char->atonic
  ;;wrong variables 
  (raise-error (strings::char->atonic 43) type-error)

  ;;greek
  (check (char= #\α (strings::char->atonic #\ά :to-upcase nil)))
  (check (char= #\Α (strings::char->atonic #\ά)))
  
  (check (char= #\Δ (strings::char->atonic #\Δ :to-upcase nil)))
  (check (char= #\Δ (strings::char->atonic #\δ)))


  ;;english
  (check (char= #\C (strings::char->atonic #\C :to-upcase nil)))
  (check (char= #\b (strings::char->atonic #\b :to-upcase nil)))
  (check (char= #\B (strings::char->atonic #\b)))

  ;;not language characters
  (check (char= #\Space (strings::char->atonic #\Space :to-upcase nil)))
  (check (char= #\Newline (strings::char->atonic #\Newline))))


(test string->atonic
  (check (string= "ΑΛΦΑ" (string->atonic "άλφα")))
  (check (string= "αλφα" (string->atonic "άλφα" :to-upcase nil)))
  (check (string= "ΑλΦα" (string->atonic "ΆλΦα" :to-upcase nil)))

  
  (check (string= "" (string->atonic "" :to-upcase nil)))
  (check (string= "" (string->atonic "" )))

  (check (string= "ALFA" (string->atonic "ALFA" :to-upcase nil))))

(test check-words
  ;;check variable errors
  (raise-error (strings::check-words 45 '("a")) type-error)
  (raise-error (strings::check-words '("a") 45) type-error)
  (raise-error (strings::check-words '("a") '(1 2 3)) type-error)
  (raise-error (strings::check-words '(1 2 3) '("a")) type-error)

  ;;happy end
  (let ((abcd (list "a" "bita" "c" "delta"))
	(bcde (list "bita" "c" "d" "e"))
	(abc (list "a" "bita" "c")))

    ;;not found
    (check-not (strings::check-words bcde abc))
    
    ;;happy end
    (check (strings::check-words abcd abc)))

  ;; empty strings
  (check (strings::check-words '("") '("")))

  ;;single item lists
  (check (Strings::check-words '("a") '("a"))))

(test replace-words-in-tokens
  ;;check variable errors
  (raise-error (strings::replace-words-in-tokens 45 45 45) type-error)
  (raise-error (strings::replace-words-in-tokens '("a") 45 45) type-error)
  (raise-error (strings::replace-words-in-tokens '("a") '("b") 45) type-error)
  (raise-error (strings::replace-words-in-tokens '(1 2 3) '("b") "f") type-error)

  ;; empty string tokens return NIL whatever search provided
  (check-not (strings::replace-words-in-tokens '() '("b") "gama"))
  (check-not (strings::replace-words-in-tokens '() '() "gama"))

  ;;not-found
   (let ((abcd (list "a" "bita" "c" "delta"))
	(bcde (list "bita" "c" "d" "e"))
	 (abc (list "a" "bita" "c")))

     ;;not found
     (check (equal abc (strings::replace-words-in-tokens abc abcd "bca")))
     (check (equal abcd (strings::replace-words-in-tokens abcd bcde "bca")))

     ;;happy end
     (check (equal '("bca" "delta") (strings::replace-words-in-tokens abcd abc "bca")))
     (check (equal '("bca" "bca" "bca") (strings::replace-words-in-tokens '("a" "a" "a") '("a") "bca")))))

(test replace-multi-word-tokens
  (let ((mwt  '((("a" "or" "b") . "a-or-b")
		(("b" "and" "c") . "b.and.c"))))
    ;;invalid input 
    (raise-error (replace-multi-word-tokens 43 :mwt mwt) type-error)
    (raise-error (replace-multi-word-tokens '("alfa" "bita") :mwt '(1 2 3)) type-error)
    (raise-error (replace-multi-word-tokens '("alfa" "bita") :mwt '((("a" "b") . ("ab"))))  type-error)

    ;;happy end
    (check (equal '("if" "there" "are" "a-or-b" "then" "b.and.c")
		  (replace-multi-word-tokens '("if" "there" "are" "a" "or" "b" "then" "b" "and" "c") :mwt mwt)))

    ;;happy end (not found any match)
    (check (equal '("a" "b" "c")
		  (replace-multi-word-tokens '("a" "b" "c") :mwt mwt)))
    ))


;;; Strings
