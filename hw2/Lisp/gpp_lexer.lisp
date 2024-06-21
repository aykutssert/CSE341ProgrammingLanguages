; KeyWordList contains a list of defined keywords.
(setq KeyWordList (list "and" "or" "not" "equal" "less" "nil" "list" "append" "concat" "set" "def" "for" "if" "exit" "load" "disp" "true" "false"))

; KW is a list containing symbolic representations of the defined keywords.
(setq KW (list "KW_AND" "KW_OR" "KW_NOT" "KW_EQUAL" "KW_LESS" "KW_NIL" "KW_LIST" "KW_APPEND" "KW_CONCAT" "KW_SET" "KW_DEF" "KW_FOR" "KW_IF" "KW_EXIT" "KW_LOAD" "KW_DISP" "KW_TRUE" "KW_FALSE"))

; OperatorList contains a list of defined operators.
(setq OperatorList (list "+" "-" "/"  "*" "(" ")"  ","))

; OP is a list containing symbolic representations of the defined operators.
(setq OP (list "OP_PLUS" "OP_MINUS" "OP_DIV" "OP_MULT" "OP_OP" "OP_CP" "OP_COMMA"))

; Comment contains the character used for comment lines.
(setq Comment ";")


; This function tokenizes the given 'word' by checking its type and printing corresponding messages.
; It uses several helper functions like 'isComment', 'isKeyWord', 'isOperator', 'isIdentifier', and 'isValuef'
; to determine the type of the 'word' and provide appropriate feedback.
(defun tokenize (word)
  (cond
    ((isComment word)
     (format t "Comment ~%")) ; Mark as a Comment and print

    ((isKeyWord word)
     (let ((index (position word KeyWordList :test #'string=)))
       (if index
           (format t "~a~%" (nth index KW))
           (format t "Unrecognized input~%"))))

    ((isOperator word)
     (let ((index (position word OperatorList :test #'string=)))
       (if index
           (format t "~a~%" (nth index OP))
           (format t "Unrecognized input~%"))))
    ((isIdentifier word)
     (format t "Identifier ~a~%" word))
    ((isValuef word)
     (format t "Valuef ~%"))
    (t
     (format t "Unrecognized input~%"))))


; This function checks if the given word is a comment line by comparing it to the Comment character.
(defun isComment (word)
  (string= (subseq word 0 (length Comment)) Comment))

; This function checks if the given word is an operator by comparing it to the OperatorList.
(defun isOperator (word)
  (member word OperatorList :test #'string=))

; This function checks if the given word is a keyword by comparing it to the KeyWordList.
(defun isKeyWord (word)
  (member word KeyWordList :test #'string=))

; This function checks if the given word is an identifier. An identifier must start with an alphabetical character
; (as determined by alpha-char-p) and should consist of alphanumeric characters (as determined by alphanumericp).
(defun isIdentifier (word)
  (and (alpha-char-p (char word 0))
       (every #'alphanumericp word)))



; This function checks if the given word represents a value with the format "number1 number2" separated by "b".
; It first splits the word using the "b" character, and then tries to parse the resulting parts as integers.
; If both parts can be successfully parsed, it returns true, indicating a recognized value; otherwise, it returns nil.
(defun isValuef (word)
  (let ((fraction (split-space "b" word)))
    (if (= (length fraction) 2)
        (let ((int1 (parse-integer (first fraction) :junk-allowed t))
              (int2 (parse-integer (second fraction) :junk-allowed t)))
          (and int1 int2))
        nil)))



; This function reads input from a file specified by the 'filename' parameter.
; It opens the file in input mode, reads each line, and tokenizes the content using the 'split-space' function.
(defun read-input-from-file (filename)
  (with-open-file (file filename :direction :input)
    (loop for line = (read-line file nil)
          while line
          do (dolist (token (split-space " " line))
              (tokenize token)))))

; This function splits a 'sequence' string into a list of substrings based on the 'separator' character.
; It scans the 'sequence' character by character, and whenever it encounters the 'separator', it creates a substring
; and appends it to the result list.
(defun split-space (separator sequence)
  (let ((result '())
        (start 0))
    (dotimes (i (length sequence))
      (if (string= (string (char sequence i)) separator)
          (progn
            (push (subseq sequence start i) result)
            (setq start (+ i 1))))
      (if (= i (1- (length sequence)))
          (push (subseq sequence start) result)))
    (nreverse result)))


; This function serves as an interactive Lisp parser. It presents a menu to the user, allowing them to choose an option.
; Options include reading input from a file, entering input manually, or exiting the program.
; Depending on the choice, it calls corresponding functions such as 'read-input-from-file' and 'tokenize' to process and tokenize input.
(defun gppinterpreter ()
  (format t "Welcome to the perfect Lisp parser.~%")
  (format t "Choose an option:~%")
  (format t "1. Read from a file~%")
  (format t "2. Enter input~%")
  (format t "3. Exit~%")
  (format t "Enter your choice: ")

  (let ((choice (read)))
    (case choice
      (1
       ; "input.gpp" as the default filename
       (let ((filename "input.gpp"))
         (read-input-from-file filename))
       )

      (2
       (loop
         (format t "input: ")
         (let ((input (read-line)))
           (if (string= input "exit")
               (return)
               (dolist (token (split-space " " input))
                (tokenize token))))))
       

      (3 (format t "Exiting program.~%"))

      (t
       (format t "Invalid choice. Please enter 1, 2, or 3.~%")
       (gppinterpreter)))))




(gppinterpreter)
