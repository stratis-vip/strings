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

### cartesian-product

```lisp
 (defun cartesian-product (&rest lsts)
  "Return the Cartesian product of LSTS.

Each argument in LSTS must be a list. The result is a list containing
all possible combinations, represented as lists, with one element taken
from each input list.

If no lists are supplied, return a list containing the empty list.
If any input list is empty, the Cartesian product is NIL.

Examples:
  (cartesian-product '(1 2) '(a b))
  => ((1 A) (1 B) (2 A) (2 B))

  (cartesian-product '(1 2) '(a b) '(x y))
  => ((1 A X) (1 A Y) (1 B X) (1 B Y)
      (2 A X) (2 A Y) (2 B X) (2 B Y))"
  ...)
 ```

### permutations-without-replacement

```lisp
(defun permutations-without-replacement (lst n &key (test #'eql))
  "Return all permutations of N elements chosen from LST without replacement.

Each result is an ordered sequence, represented as a list of length N.
An element of LST can occur at most once in any individual sequence.
The TEST function determines when two elements are considered equal
and is used when removing an element after it has been selected.

If N is zero, return a list containing the empty list.
If N is greater than the length of LST, return NIL.

Examples:
  (permutations-without-replacement '(1 2 3) 2)
  => ((1 2) (1 3) (2 1) (2 3) (3 1) (3 2))

  (permutations-without-replacement '(1 2 3) 0)
  => (NIL)

  (permutations-without-replacement '(1 2 3) 4)
  => NIL."
  ...)
```

### combine-any-predicates

```lisp
(defun combine-any-predicates  (&rest list-of-functions)
  "Return a predicate that succeeds when any predicate succeeds.

LIST-OF-FUNCTIONS is a list of predicate functions.  The returned
predicate accepts one argument X and returns a true value when at least
one of the predicates in LIST-OF-FUNCTIONS returns a true value for X.

This is equivalent to a logical OR of the supplied predicates.

Examples:

  (funcall (combine-any-predicates #'evenp #'oddp) 3)
  => T

  (funcall (combine-any-predicates #'evenp #'zerop) 3)
  => NIL"
  ...)
  ```
  
### combile-all-predicates
```lisp
(defun combine-all-predicates  (&rest list-of-functions)
  "Return a predicate that succeeds when all predicates succeed.

LIST-OF-FUNCTIONS is a list of predicate functions.  The returned
predicate accepts one argument X and returns a true value only when
every predicate in LIST-OF-FUNCTIONS returns a true value for X.

This is equivalent to a logical AND of the supplied predicates.

Examples:

  (funcall (combine-all-predicates #'integerp #'evenp) 4)
  => T

  (funcall (combine-all-predicates #'integerp #'evenp) 3)
  => NIL"
...)
```

## Predicates
### memberp

```lisp
(defun memberp (item lst &key (test #'eql))
  "Check if ITEM is in LST against TEST function.

   ITEM any value
   LST a list of any type
   TEST the equality function

   Returns T if item is in the LST. Else NIL or TYPE-ERROR if no list or no-function given."
...)
```
###  has-no-duplicates-p
```lisp
(defun has-no-duplicates-p (lst &key (test #'eql))
  "Checks if the list LST has duplicates members.
Returns T if list has no duplicates and (VALUES nil, duplicate-position),
where duplicate-position is the first occurence of the duplicate item"
...)
```

### has-more-than-n-p
```lisp
(defun has-more-than-n-p (list n &key (equal nil))
  "Returns T if LIST Length > n. if EQUAL set to T then 
N     any positive integer
LIST  any list
EQUAL check if N = lenght LIST

This function stops immidiately when it counts n+1 items, so it doesn't
traverse the wjole list.

In case of invalid input, returns nil immidiately"
...)
```
### is-list-of-p 
```lisp
(defun is-list-of-p (list combiner &rest predicates)
    "Return true when every element of LIST satisfies the combined predicates.

COMBINER is a function that accepts the predicates in PREDICATES and
returns a single predicate.  The resulting predicate is then applied
to every element of LIST.

PREDICATES must therefore be functions accepting one argument and
returning a generalized boolean.

For example, using COMBINE-ANY-PREDICATES requires every element of LIST
to satisfy at least one of the supplied predicates:

  (is-list-of-p '(1 2 3 4)
                #'combine-any-predicates
                #'evenp
                #'oddp)
  => T

Using COMBINE-ALL-PREDICATES requires every element of LIST to satisfy
all of the supplied predicates:

  (is-list-of-p '(2 4 6)
                #'combine-all-predicates
                #'integerp
                #'evenp)
  => T

  (is-list-of-p '(2 4 7)
                #'combine-all-predicates
                #'integerp
                #'evenp)
  => NIL"
  ...)
```
