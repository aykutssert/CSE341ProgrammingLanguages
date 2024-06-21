
(defparameter keywordList '(("and" "KW_AND") ("or" "KW_OR") ("not" "KW_NOT") ("equal" "KW_EQUAL") ("less" "KW_LESS") ("nil" "KW_NIL") ("list" "KW_LIST")("append" "KW_APPEND") 
("concat" "KW_CONCAT") ("set" "KW_SET") ("deffun" "KW_DEF") ("defvar" "KW_DEF") ("for" "KW_FOR") ("if" "KW_IF")("exit" "KW_EXIT") 
("load" "KW_LOAD") ("display" "KW_DISPLAY") ("true" "KW_TRUE") ("false" "KW_FALSE")))

(defparameter operatorList '(("+" "OP_PLUS")("-" "OP_MINUS") ("/" "OP_DIV") ("*" "OP_MULT") ("(" "OP_OP") (")" "OP_CP") ("," "OP_COMMA") ))

(defparameter CommentList '((";" "Comment")))


(defparameter  isExit nil)

(defparameter token_list ())        
(defparameter other_tokens "")   


;; Function initializes the GPP lexer and creates the token list.
  ;; Parameter: filename - Name of the file to be examined (optional).
  ;; Return Value: Token list.
(defun gpp-lexer (&optional filename)
    (if filename
        (read-from-file filename)
        (read-from-user))
    (setf token_list (reverse token_list)) 
    
)

(defun print-token-list ()
  (format t "Token List: ~a~%" token_list))


;; Function performs lexer by reading from a file.
  ;; Parameter: filename - Name of the file to be examined.
(defun read-from-file (filename)
  (with-open-file (stream filename :direction :input)
    (do ((current (read-char stream nil) (read-char stream nil)))
        ((not current))
      (tokenize current))))


(defun read-from-user ()
(format t "> ")  ;kullanıcıdan giriş almak için belirteç
  (unwind-protect
      (loop :for current := (read-char nil) :do
          (tokenize current)  ;tokenize işlemi yapılır ve token-list'e eklenir.
          (cond 
              (isExit (return-from read-from-user nil)) ;exit-flag true ise fonksiyondan çık
              ((char= current #\Newline) ;eğer newline girilirse kullanıcıdan tekrar input iste
                  (progn        
                      (format t "> ")
                  ))
          ))
    (format t "~%Exiting...~%")))  ; unwind-protect ile çıkış yapılırken her durumda çalışacak olan kod bloğu



;; Function adds the character to the token list or processes it.
  ;; Parameter: current - The character being examined.
(defun tokenize (current)
  (cond     
    ((is-ending current)
     (handle-ending current))
    (t
     (handle-non-ending current))
    )
)

(defun handle-ending (current)

;; Function performs the action when a terminator character is encountered.
  ;; Parameter: current - The examined character.
  (if (> (length other_tokens) 0)
      (progn 
        (setf result nil)
        (cond                        
          ((setf result (keyword_find other_tokens))
           (if (string= other_tokens "exit") 
               (setf isExit t)) 
           (push result token_list))

          ((setf result (operator_find other_tokens))
           (push result token_list))

          ((is-valueb other_tokens)
           (push (list (parse-valueb other_tokens) "VALUEB") token_list))

            )
        (setf other_tokens "")))
  (if (or (string= current "(") (string= current ")"))
      (push (operator_find current) token_list)))

;; Function performs the action when a non-terminator character is encountered.
  ;; Parameter: current - The examined character.
(defun handle-non-ending (current)
  (setf other_tokens (concatenate 'string other_tokens (string current))))




;; Function checks whether a number has a leading zero.
  ;; Parameter: isLeading - The number being checked.
  ;; Return Value: If there is only zero at the beginning, returns nil; otherwise, returns t.
(defun is-leading-zero (is-leading)
  (and (= (length is-leading) 1)
       (char= (char is-leading 0) #\0)))

;; Function checks whether a character is a digit.
  ;; Parameter: isDigit - The examined character.
  ;; Return Value: If the character is a digit, returns t; otherwise, returns nil.
(defun is-digit (is-digit)
  (digit-char-p is-digit))


;; Function checks whether a value is of type VALUEB.
  ;; Parameter: isValueb - The examined value.
  ;; Return Value: If the value is VALUEB, returns t; otherwise, returns nil.
(defun is-valueb (isValueb)
  (and (not (is-leading-zero isValueb))
       (is-valueb-helper isValueb 0 (length isValueb) nil)))

;; Function checks whether a value is of type VALUEB (helper function).
  ;; Parameter: isValueb - The examined value.
  ;; Parameter: current - The index of the examined character.
  ;; Parameter: end - The length of the value.
  ;; Parameter: valueb - Flag indicating whether the value is of type VALUEB.
  ;; Return Value: If the value is VALUEB, returns t; otherwise, returns nil.
(defun is-valueb-helper (is-valueb current end valueb)
  (cond 
    ((= current end) valueb)
    ((is-digit (char is-valueb current))
     (is-valueb-helper is-valueb (1+ current) end valueb))
    ((char= (char is-valueb current) #\b)
     (is-valueb-helper is-valueb (1+ current) end t))
    (t nil)))


;; Function parses a VALUEB expression.
  ;; Parameter: valueb - The VALUEB expression to be parsed.
  ;; Return Value: The parsed value.
(defun parse-valueb (valueb)
  (let* ((i (position #\b (coerce valueb 'list)))
         (num (and i (parse-integer (subseq valueb 0 i))))
         (denom (and i (parse-integer (subseq valueb (1+ i))))))
    (and num denom (/ num denom))))



;; Function checks whether a character is a terminator.
  ;; Parameter: isEnding - The examined character.
  ;; Return Value: If it is a terminator, returns t; otherwise, returns nil.
(defun is-ending (isEnding)
  (member isEnding '(#\Space #\Newline #\Tab #\( #\))))


;; Function searches for the specified element in the operators list.
  ;; Parameter: elem - The element being searched for.
  ;; Return Value: If found, returns the corresponding element; otherwise, returns nil.
(defun operator_find (elem)
    (assoc elem operatorList :test #'string=)
)

;; Function searches for the specified element in the comments list.
  ;; Parameter: elem - The element being searched for.
  ;; Return Value: If found, returns the corresponding element; otherwise, returns nil.
(defun comment_find (elem)
    (assoc elem CommentList :test #'string=)
)

;; Function searches for the specified element in the keyword list.
  ;; Parameter: elem - The element being searched for.
  ;; Return Value: If found, returns the corresponding element; otherwise, returns nil.
  
(defun keyword_find (elem)
    (assoc elem keywordList :test #'string=)
)

