# Strings utilities

A collection of utilities for strings. These utilities were needed for my projects.

# Overview

Utilities about strings manipulation. Making my life easier.

# Usage

## Installation

You need to clone this repo to a position that common lisp recognize (usually to ~/common-lisp/).
This package depends on: 

* [lists](https://github.com/stratis-vip/lists)
* [review for testing](https://github.com/stratis-vip/review)

After that you can load package with 
```lisp 
(asdf:load-system :strings)
(asdf:load-system :strings/tests)
```

## Functions

### string-atonic

```lisp 
(defun string->atonic (phrase &key (to-upcase t))
  "Convert a PHRASE to the same one without tones. Phrase is returned to UPPERCASE unless UPCASE set to nil"
   ...)
 ```

### take 

```lisp
 defun take (phrase n)
  "Returns a STRING (the first N characters of the string PHRASE). N must be 0 or positive integer.

Raise an error if wrong type variables provided"
  ...)
 ```

### drop 

```lisp
(defun drop (phrase n)
  "Returns a STRING (the characteres after n-first of the  string PHRASE).#strings.lisp  N must be 0 or positive integer.

Raise an error if wrong type variables provided." 
  ...)
```

### split-by

```lisp
(defun split-by (phrase &key (separator *spaces*))
  "Split a string PHRASE to a list of strings. Characters to split the words are in the non empty SEPARATOR list.
Returns a list of string, or the same string if not any separators found and nil if empty phrase provided.

If PHRASE is not of type STRING or separator is nil,it raise an ERROR"
  ...)
  ```
  
### trim 
```lisp
(defun trim (phrase &key (trim-chars *spaces*))
 "Remove all characters belongs to TRIM-CHARS list, from the front
and the end of the string PHRASE.

Raise an error if PHRASE is not String or TRIM_CHARS is not a list of chars"
  => NIL"
...)
```

### trim-left
```lisp
(defun trim-left (phrase &key (trim-chars *spaces*))
  "Remove all characters belongs to TRIM-CHARS list, from the front
of the string PHRASE.

Raise an error if PHRASE is not String or TRIM_CHARS is not a list of chars"
...)
```


### trim-right
```lisp
  "Remove all characters belongs to TRIM-CHARS list, from the end
of the string PHRASE.

Raise an error if PHRASE is not String or TRIM_CHARS is not a list of chars"
  (check-type phrase string)
...)
```
### replace-multi-word-tokens
```lisp
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
..)
```

## Predicates
### char-list-p

```lisp
(defun char-list-p (x)
  (and (listp x)
       (every #'characterp x))
  )
```
