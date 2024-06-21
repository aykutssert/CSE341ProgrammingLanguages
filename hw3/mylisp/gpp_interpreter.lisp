;"The global variable storing the output file name."
(defparameter *output* "output.txt")

;"The global variable indicating whether an exit statement is encountered."
(defparameter *isExit* nil)

;"Load the GPP lexer module."
(load "gpp_lexer.lisp")

;"The function closes a stream."
(defun close-stream (stream)
  (when (streamp stream)
    (close stream)))



(defun gppinterpreter (&optional input-file)
  (let ((output-stream (if input-file (open *output* :direction :output) t)))
    ;; Step 1: Iterate over each input file (or the default nil if not provided)
    (dolist (input (if input-file input-file (list nil)))
      ;; Step 2: Call the helper function with the lexer result and the output stream
      (helper (gpp-lexer input) output-stream))
    ;; Step 3: Close the output stream if it was opened
    (close-stream output-stream)))



(defun helper (token-list output-stream)
  
  (when token-list
    ;; Step 1: Parse the current token list
    (let ((parse-result ($START token-list)))
      (when parse-result
        ;; Step 2: Get the parsed value
        (let ((parsed-value (car parse-result)))
          (when parsed-value
            ;; Step 3: Print the result to the specified stream or standard output
            (if output-stream
                (format output-stream "Result: ~s~%"
                        (if (numberp parsed-value) (convert_valueb parsed-value) parsed-value))
                (format t "Result: ~s~%"
                        (if (numberp parsed-value) (convert_valueb parsed-value) parsed-value)))
            ;; Step 4: If the exit flag is not set, continue with the next token list
            (unless *isExit*
              (helper (cadr parse-result) output-stream)))
          ;; Step 5: If the parsed value is nil, print a syntax error message
          (unless parsed-value
            (if output-stream
                (format output-stream "SYNTAX_ERROR")
                (format t "SYNTAX_ERROR"))))))))



    




    (defun print-token-listt (tokens)
  (format t "Token List: ~a~%" tokens))


;; The function starts the interpretation process and calls the $INPUT function.
;; Parameter: tokens - List of tokens examined.
;; Return Value: The result of the interpretation operation and the remaining list of tokens.
(defun $START (tokens)
    ($INPUT tokens))

(defun $INPUT (tokens)
    ;; The function checks an INPUT statement and redirects it to the $EXIT or $EXP functions.
   ;; Parameter: tokens - List of tokens examined.
   ;; Return Value: The result of the EXIT or EXP statement and the list of remaining tokens.
    (let ((result))
        (cond 
            ((car (setq result ($EXIT tokens))) result)
            ((car (setq result ($EXP tokens))) result)
            )))


;; The function checks an EXIT statement and updates the *isExit* state.
;; Parameter: tokens - List of tokens examined.
;; Return Value: The result of the EXIT statement and the list of remaining tokens.
(defun $EXIT (tokens)
  "The function checks an EXIT statement."
  (case (list (next-token tokens) (next-token (cdr tokens)))
    (("OP_OP" "KW_EXIT") (setq *isExit* t) (return_result "1b0" (cddr tokens)))
    (t (return_result nil tokens))))



;; The function evaluates an EXP expression and returns the result.
;; Parameter: tokens - List of tokens examined.
;; Return Value: The value of the EXP expression and the remaining token list.
(defun $EXP (tokens)
  (let ((result))
    (cond 
      
      ((car (setq result ($VALUEB tokens))) result)
      (t
       (let ((result nil) (valueb1 nil) (valueb2 nil) (operator nil))
         
         ;; Check the left parenthesis and skip it.
         (if (string= (next-token tokens) "OP_OP")
             (setq tokens (cdr tokens)) 
             (return-from $EXP (return_result nil tokens))) 
       
        ;; Control the operator and jump.
         (if (isOperator (next-token tokens)) 
             (progn
               (setq operator (next-token tokens))
               (setq tokens (cdr tokens)))
             (return-from $EXP (return_result nil tokens)))

        ;; Evaluate first VALUEB expression
         (setq result ($EXP tokens))
         (if (car result)
             (progn 
               (setq valueb1 (car result))
               (setq tokens (cadr result)))
             (return-from $EXP (return_result nil tokens)))

        ;; Evaluate the second VALUEB expression.
         (setq result ($EXP tokens))
         (if (car result) 
             (progn 
               (setq valueb2 (car result))
               (setq tokens (cadr result)))
             (return-from $EXP (return_result nil tokens)))
        
        ;; Check the right parenthesis and skip it.
         (if (string= (next-token tokens) "OP_CP") 
             (setq result (return_result (Operating operator valueb1 valueb2) tokens)) 
             (return-from $EXP (return_result nil tokens)))
         result)))))


        


        
;; The function evaluates a VALUEB expression and returns the result.
;; Parameter: tokens - List of tokens examined.
;; Return Value: The value of the VALUEB expression and the remaining token list.         
(defun $VALUEB (tokens)
    
    (let ((token (next-token tokens)) (v nil))
        (if (string= token "VALUEB") 
            (setq v (next-value tokens)))
        (return_result v tokens)))




;; The function checks if a mathematical operator exists from a string.
;; Parameter: str - The string to check.
;; Return Value: t if the string is a mathematical operator, otherwise nil
(defun isOperator (str)
    (or (string= str "OP_PLUS") (string= str "OP_MINUS") (string= str "OP_MULT") (string= str "OP_DIV")))


;; The function returns a double that represents the result of an interpretation operation.
;; Parameter: is-success - Boolean value indicating whether the interpretation process was successful or not.
;; Parameter: token-list - List of tokens obtained in case of successful interpretation or
;; List of relevant tokens in case of error.
;; Return Value: A pair (is-success t) and a list of tokens in case of successful transaction.
;; A list of pairs (is-success nil) and associated tokens in case of failed transactions.
(defun return_result (is-success token-list)
  (if is-success
      (cons is-success (list (cdr token-list)))
      (cons is-success (list token-list))))


(defun next-token (token-list) 
    (cadar token-list)) ;;This expression returns the next element of the double list at the beginning of a list.

;; The function retrieves and returns the next value from a list of tokens.
;; Parameter: token-list - List of tokens to examine.
;; Return Value: The value at the beginning of the token list.
(defun next-value (token-list)
    (caar token-list)) ;;This expression returns the element at the beginning of a double list at the beginning of a list.


;; The function formats a fractional number as a string.
;; Parameter: v - Fractional number to format.
;; Return Value: String form of the fractional number.
(defun convert_valueb (v)
    (format nil "~sb~s" (numerator v) (denominator v)))

;; The function evaluates two VALUEB expressions according to a mathematical operator.
;; Parameter: operator - Mathematical operator (OP_PLUS, OP_MINUS, OP_DIV, OP_MULT).
;; Parameter: valueb1 - The value of the first VALUEB expression.
;; Parameter: valueb2 - The value of the second VALUEB expression.
;; Return Value: Value of two VALUEB expressions and based on mathematical operator
;; evaluated result.
(defun Operating (operator valueb1 valueb2)
    
    (cond
        ((string= operator "OP_PLUS") (+ valueb1 valueb2))
        ((string= operator "OP_MINUS") (- valueb1 valueb2))
        ((string= operator "OP_DIV") (/ valueb1 valueb2))
        ((string= operator "OP_MULT") (* valueb1 valueb2))))


(gppinterpreter *args*)
