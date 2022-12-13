(defun aoc-compare-packets-debug ())

(defun aoc-compare-packets (left right)
  (let ((l-head (car left))
        (r-head (car right)))
    ;; (message (format "comparing: [%s][%s]" l-head r-head))
    (let ((found
           (cond
            ((and (not l-head) (not r-head) 0))

            ;; If the left list runs out of items first, the inputs are in the right order.
            ((and (not l-head) r-head) 1)

            ;; If the right list runs out of items first, the inputs are not in the right order
            ((and l-head (not r-head) -1))

            ;; if both values are integers, the lower integer should come first
            ((and (integerp l-head) (integerp r-head))
             (cond
              ;; If the left integer is lower than the right integer, the inputs are in the right order.
              ((< l-head r-head) 1)

              ;; If the left integer is higher than the right integer, the inputs are not in the right order
              ((> l-head r-head) -1)

              ;; Otherwise, the inputs are the same integer; continue checking the next part of the input.
              (t (aoc-compare-packets (cdr left) (cdr right)))))

            ;; If both values are lists, compare the first value of each list, then the second value, and so on.
            ((and (listp l-head) (listp r-head)) (let ((comparison (aoc-compare-packets l-head r-head)))
                                                   (if (eq 0 comparison)
                                                       (aoc-compare-packets (cdr left) (cdr right))
                                                     comparison
                                                     )))

            ((and (integerp l-head) (listp r-head)) (let ((comparison (aoc-compare-packets (-list l-head) r-head)))
                                                      (if (eq 0 comparison)
                                                          (aoc-compare-packets (cdr left) (cdr right))
                                                        comparison
                                                        )))
            ((and (listp l-head) (integerp r-head)) (let ((comparison (aoc-compare-packets l-head (-list r-head))))
                                                      (if (eq 0 comparison)
                                                          (aoc-compare-packets (cdr left) (cdr right))
                                                        comparison
                                                        )))

            (t 0))))
      ;; (message (format "%s" found))
      found)))

;;; one
(->> (f-read "data")
     (s-replace "," " ")
     (s-replace "[" "(")
     (s-replace "]" ")")
     (aoc-s-split "\n")
     (--filter it)
     (--map (eval (car (read-from-string (format "'%s" it)))))
     (-partition 2)
     ;; (--map (message (format "%s" it)))
     (--map (apply 'aoc-compare-packets it))
     (--map-indexed `(,(+ 1 it-index) ,it))
     (--filter (> (cadr it) 0))
     (--map (car it))
     (-sum)
     ;; (number-to-string)
     ;; (kill-new)
     )

;;; two
(->> (f-read "data")
     (s-append "\n[[2]]
[[6]]")
     (s-replace "," " ")
     (s-replace "[" "(")
     (s-replace "]" ")")
     (aoc-s-split "\n")
     (--map (eval (car (read-from-string (format "'%s" it)))))
     (--sort (not (eq -1 (aoc-compare-packets it other))))
     ;; (--map (format "%s" it))
     ;; (s-join "\n")
     (--find-indices (or (equal '((2)) it)
                         (equal '((6)) it)))
     (--map (+ 1 it))
     (-product)
     (number-to-string)
     (kill-new))
