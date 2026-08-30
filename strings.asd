(defsystem :strings
  :description "Strings utilities for general use"
  :author "Stratis Christodoulou <stratis.vip@gmail.com"
  :version "1.0"
  
  :depends-on ("lists")
  :pathname "src"
  :serial t
  
  :components ((:file "package")
               (:file "strings"))

  :in-order-to ((test-op (test-op "strings/tests"))))

(defsystem :strings/tests 
  :description "Test suite for strings"

  :depends-on ("review" "lists" "strings")
  
  :pathname "tests"
  :serial t
  :components ((:file "package")
	       (:file "test-setup")
               (:file "strings-tests"))
  
   :perform (test-op (op c)
                    (uiop:symbol-call :review :run-tests
                                      ;:show-only-errors t 
                                      ;:color t
				      )))
