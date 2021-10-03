;;;; Challenge02: Firmware
;;;; Common Lisp solution by Tom Faughnan

;;; Global variables

(defvar *firmware* ())
(defvar *firmware-fixed* ())
(defvar *pc* 0)
(defvar *pc-history* ())
(defvar *acc* 0)

;;; Parsing helper functions

(defun parse-binary-string (binary-string start &optional end)
  (parse-integer (subseq binary-string
                         start
                         end)
                 :radix 2))

(defun get-operation (instruction-string)
  (parse-binary-string instruction-string
                       0
                       2))

(defun get-argument (instruction-string)
  (* (truncate (* (- 1/2
                     (parse-binary-string instruction-string
                                          2
                                          3))
                     3))
     (parse-binary-string instruction-string
                          3)))

(defun make-instruction (instruction-string)
  (list :operation (get-operation instruction-string)
        :argument (get-argument instruction-string)))

;;; Record value of program counter, then increment it accordingly

(defun set-pc (increment)
  (push *pc*
        *pc-history*)
  (setf *pc*
        (+ *pc*
           increment)))

;;; NOP, ACC, JMP operations

(defun do-nop ()
  (set-pc 1))

(defun do-acc (argument)
  (setf *acc*
        (+ *acc*
           argument))
  (set-pc 1))

(defun do-jmp (argument)
  (set-pc argument))

;;; Perform a given instruction by delegating
;;; to NOP, ACC, or JMP handler

(defun do-instruction (instruction)
  (case (getf instruction
              :operation)
    (0 (do-nop))
    (1 (do-acc (getf instruction
                     :argument)))
    (2 (do-jmp (getf instruction
                     :argument)))))

;;; Run instructions for a given firmware list until infinite loop detected
;;; or program counter exceeds last instruction

(defun run-firmware-until-repeat-or-termination (firmware)
  (loop while (and (< *pc*
                      (length firmware))
                   (not (member *pc*
                                *pc-history*)))
        do (do-instruction (nth *pc*
                                firmware))))

;;; Reset "fixed" firmware as an independent copy of original firmware
;;; Had to do it this way for... reasons -- it's not clean, but it works

(defun reset-firmware-fixed ()
  (setf *firmware-fixed* ())
  (loop for i from 0 to (- (length *firmware*)
                           1)
        do (setf *firmware-fixed*
                 (append *firmware-fixed*
                         (list (copy-list (nth i
                                               *firmware*)))))))


;;; Swap a NOP for a JMP (or vice-versa), then test the "fixed" firmware
;;; via run-firmware-until-repeat-or-termination

(defun swap-and-run (index new)
  (reset-firmware-fixed)
  (setf *pc* 0)
  (setf *pc-history* ())
  (setf *acc* 0)
  (setf (getf (nth index *firmware-fixed*) :operation) new)
  (run-firmware-until-repeat-or-termination *firmware-fixed*))

;;; Populate firmware with instructions from stdin

(loop for line = (read-line *standard-input*
                            nil
                            nil)
      while line do (setf *firmware*
                          (append *firmware*
                                  (list (make-instruction line)))))

;;; Solve Part A

(run-firmware-until-repeat-or-termination *firmware*)
(format t "Part A: ~a~%" *acc*)

;;; Solve Part B

(loop for i from 0 to (- (length *firmware*)
                         1)
      do (case (getf (nth i
                          *firmware*)
                     :operation)
           (0 (swap-and-run i
                            2))
           (1 nil)
           (2 (swap-and-run i
                            0)))
      (when (>= *pc* (length *firmware-fixed*))
        (format t "Part B: ~a~%" *acc*)
        (setf i (length *firmware*))))
