;;;; Challenge01: Cipher
;;;; Common Lisp solution by Tom Faughnan

(defun decrypt-letter (cletter kletter)
  (code-char (+ (char-code #\A)
                (mod (- (char-code cletter)
                        (char-code kletter))
                     (+ (- (char-code #\Z)
                           (char-code #\A))
                        1)))))

(defun decrypt (cstring key)
  (coerce (mapcar #'decrypt-letter
                  (coerce cstring
                          'list)
                  (coerce (format nil "~v@{~a~:*~}"
                                  (length cstring)
                                  key)
                          'list))
          'string))

(format t "Username: ~A~%Password: ~A~%"
        (decrypt "UQUFH" "UNIX")
        (decrypt "CNUDLBWQ" "UNIX"))
