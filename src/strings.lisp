;;; file STRINGS:src/strings.lisp
;;;
;;; Code:

(in-package :strings)

(defparameter *spaces* '(#\Space #\Tab #\Newline))


(defun take (phrase n)
  "Returns a STRING (the first N characters of the string PHRASE). N must be 0 or positive integer.

Raise an error if wrong type variables provided"
  (check-type phrase string )
  (check-type n (integer 0))
  (subseq phrase 0 (min (length phrase) n)))

(defun drop (phrase n)
  "Returns a STRING (the characteres after n-first of the  string PHRASE).#strings.lisp  N must be 0 or positive integer.

Raise an error if wrong type variables provided." 
  (check-type phrase string)
  (check-type n (integer 0))
  (subseq phrase (min n (length phrase))))

(defun char-list-p (x)
  (and (listp x)
       (every #'characterp x))
  )

(defun string-list-p (x)
  (and (listp x)
       (every #'stringp x))
  )

(defun stringlist-string-alist-p (x)
  "Returns T if X is an alist whose keys are lists of strings
and whose values are strings.

For example:

  ((\"greater\" \"or\" \"equal\") . \"greater-or-equal\")
  ((\"less\" \"or\" \"equal\") . \"less-or-equal\")

Returns NIL otherwise."
  (and (listp x)
       (every (lambda (entry)
                (and (consp entry)
                     (string-list-p (car entry))
                     (stringp (cdr entry))))
              x)))

(defun split-by (phrase &key (separator *spaces*))
  "Split a string PHRASE to a list of strings. Characters to split the words are in the non empty SEPARATOR list.
Returns a list of string, or the same string if not any separators found and nil if empty phrase provided.

If PHRASE is not of type STRING or separator is nil,it raise an ERROR"
  (check-type phrase string)
  (check-type separator (satisfies char-list-p))
  (cond
    ((string= phrase "") '())
    ((null separator) (error "Separator must not be empty!"))
    (t (remove-if (lambda (x) (string= x ""))
		  (uiop:split-string
		   (trim phrase :trim-chars separator)
		   :separator separator)))))

(defun trim-left (phrase &key (trim-chars *spaces*))
  "Remove all characters belongs to TRIM-CHARS list, from the front
of the string PHRASE.

Raise an error if PHRASE is not String or TRIM_CHARS is not a list of chars"
  (check-type phrase string)
  (check-type trim-chars (satisfies char-list-p))

  (when (null trim-chars)
      (error "Trim chars must not be empty!"))

  (loop for i from 0 below (length  phrase)
		     when (not (memberp (char phrase i) trim-chars))
		     do (return (subseq phrase i))
		     finally (return "")))

(defun trim-right (phrase &key (trim-chars *spaces*))
  "Remove all characters belongs to TRIM-CHARS list, from the end
of the string PHRASE.

Raise an error if PHRASE is not String or TRIM_CHARS is not a list of chars"
  (check-type phrase string)
  (check-type trim-chars (satisfies char-list-p))
  
  (when (null trim-chars)
      (error "Trim chars must not be empty!"))

  (reverse (trim-left (reverse phrase) :trim-chars trim-chars)))

(defun trim (phrase &key (trim-chars *spaces*))
 "Remove all characters belongs to TRIM-CHARS list, from the front
and the end of the string PHRASE.

Raise an error if PHRASE is not String or TRIM_CHARS is not a list of chars"
  (check-type phrase string)
  (check-type trim-chars (satisfies char-list-p))
  
  (when (null trim-chars)
    (error "Trim chars must not be empty!"))

  (trim-right (trim-left phrase :trim-chars trim-chars) :trim-chars trim-chars))

(defun char->atonic (ch &key (to-upcase t))
  "Converts CH to its uppercase, tonos-free Greek equivalent.

If CH is a Greek character with a tonos, its tonos is removed.
Final case is uppercase by default. If TO-UPCASE is NIL, the result
is converted to lowercase.

Characters that are not in the tonos table are left unchanged,
apart from case conversion (UPPERCASE by default or to as-is if TO-UPCASE set to NIL)"

  (check-type ch character)

  (let* ((tones '((#\Ά . #\Α)
                  (#\Έ . #\Ε)
                  (#\Ή . #\Η)
                  (#\Ί . #\Ι)
                  (#\Ό . #\Ο)
                  (#\Ύ . #\Υ)
                  (#\Ώ . #\Ω)
                  (#\ΐ . #\Ι)
                  (#\Ϊ . #\Ι)
                  (#\Ϋ . #\Υ)
                  (#\ς . #\Σ)))
         (upper (char-upcase ch))
         (atonic (or (cdr (assoc upper tones :test #'char=))
			    upper)))

    (if (or (and (null to-upcase) (upper-case-p ch))
	     to-upcase)
        atonic
        (char-downcase atonic))))

(defun string->atonic (phrase &key (to-upcase t))
  "Convert a PHRASE to the same one without tones. Phrase is returned to UPPERCASE unless UPCASE set to nil"
  (check-type phrase string)
  (coerce (loop for c across phrase
		collect (char->atonic c :to-upcase to-upcase))
	  'string))

(defun merge-comparison-words (words)
  (cond
    ((null words)
     nil)

    ((and (string-equal (first words) "GREATER")
          (second words)
          (string-equal (second words) "OR")
          (third words)
          (string-equal (third words) "EQUAL"))
     (cons "GREATER-OR-EQUAL"
           (merge-comparison-words (cdddr words))))

    ((and (string-equal (first words) "LESS")
          (second words)
          (string-equal (second words) "OR")
          (third words)
          (string-equal (third words) "EQUAL"))
     (cons "LESS-OR-EQUAL"
           (merge-comparison-words (cdddr words))))

    (t
     (cons (first words)
           (merge-comparison-words (rest words))))))


(defparameter *multi-word-tokens*
  '((("greater" "or" "equal") . "greater-or-equal")
    (("less" "or" "equal")    . "less-or-equal")
    (("greater" "or" "less")  . "greater-or-less")
    (("less" "or" "greater")  . "less-or-greater")))

(defparameter *example-mwt*
  '((("a" "or" "b") . "a-or-b")
    (("b" "and" "c") . "b.and.c")))


(defun check-words (words search)
  "Returns T if SEARCH matches the beginning of WORDS, NIL otherwise.

Both WORDS and SEARCH must be lists of strings. The comparison is
performed element by element using STRING=.

SEARCH is considered a match only if all of its elements occur
consecutively at the beginning of WORDS. An empty SEARCH list matches
any WORDS list.

Signals an error if WORDS or SEARCH is not a list of strings."
  
  (check-type words (satisfies string-list-p))
  (check-type search (satisfies string-list-p))
  
  (cond
    ((> (length search) (length words))
     nil)

    ((null search)
     t)

    ((string= (first words) (first search))
     (check-words (rest words)
                  (rest search)))

    (t
     nil)))

(defun replace-words-in-tokens (tokens search replacement)
  "Replaces occurrences of SEARCH in TOKENS with REPLACEMENT.

SEARCH must match consecutive tokens beginning at a given position.
When a match is found, all tokens belonging to SEARCH are removed and
REPLACEMENT is inserted in their place.

The function continues scanning after the replaced sequence, so every
non-overlapping occurrence of SEARCH is replaced.

Returns a new list of tokens. The original TOKENS list is not modified.
NIL tokens return also NIL.

Signals an error if TOKENS or SEARCH is not a list of strings."
  (check-type tokens (satisfies string-list-p))
  (check-type search (satisfies string-list-p))
  (check-type replacement string)
  (labels ((helper (tokens acc)
             (cond
               ((null tokens)
                (reverse acc))

               ((check-words tokens search)
                (helper
                 (nthcdr (length search) tokens)
                 (cons replacement acc)))

               (t
                (helper
                 (rest tokens)
                 (cons (first tokens) acc))))))
    (helper tokens '())))

(defun replace-multi-word-tokens (tokens &key mwt)
   "Replaces all registered multi-word expressions in TOKENS.

The replacements are defined by *MULTI-WORD-TOKENS*. Each entry
contains a sequence of words to search for and the single token that
replaces that sequence.

Returns a new list of tokens with all registered multi-word
expressions replaced.

The replacements are applied sequentially in the order in which
they appear in *MULTI-WORD-TOKENS*.

The original TOKENS list is not modified.

Signals an error if TOKENS is not a list of strings."
  (check-type tokens (satisfies string-list-p))
  (check-type mwt (satisfies stringlist-string-alist-p))

  "Replaces all registered multi-word expressions in TOKENS.

The replacements are defined by *MULTI-WORD-TOKENS*. Each entry
contains a sequence of words to search for and the single token that
replaces that sequence.

Returns a new list of tokens with all registered multi-word
expressions replaced.

The replacements are applied sequentially in the order in which
they appear in *MULTI-WORD-TOKENS*.

The original TOKENS list is not modified.

Signals an error if TOKENS is not a list of strings."
  (dolist (entry mwt tokens)
    (setf tokens
          (replace-words-in-tokens
           tokens
           (car entry)
           (cdr entry)))))



;;; STRINGS:src/strings.lisp ends here
