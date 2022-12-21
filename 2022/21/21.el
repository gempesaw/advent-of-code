(defun aoc-define-monkey (parts)
  (let ((function-name (s-concat "aoc-monkey-" (car parts)))
        (equation (cdr parts)))
    (fset (intern function-name)
          (if (eq 1 (length equation))
              `(lambda () ,(string-to-number (car equation)))
            `(lambda ()
               (,(car (read-from-string (nth 1 equation)))
                (,(intern (s-concat "aoc-monkey-" (nth 0 equation))))
                (,(intern (s-concat "aoc-monkey-" (nth 2 equation))))))))))

;;; example
(progn
  (when nil
    (--> (aoc-data-as-lines "example")
         (--map (aoc-s-split ":\\| " it) it)
         (-each it 'aoc-define-monkey)
         )
    (aoc-monkey-root)))


;;; one
(progn
  (when t
    (--> (aoc-data-as-lines)
         (--map (aoc-s-split ":\\| " it) it)
         (-each it 'aoc-define-monkey)
         )
    (aoc-monkey-root)
    (symbol-function 'aoc-monkey-root)))

(- (aoc-monkey-mrnz) (aoc-monkey-jwrp))


(defun aoc-expand-absolute (table key)
  (let ((expansion (ht-get table key)))
    (if (eq 1 (length expansion))
        expansion
      (-concat
       '("(") (aoc-expand-absolute table (nth 0 expansion))
       `(,(nth 1 expansion))
       (aoc-expand-absolute table (nth 2 expansion)) '(")")
       )
      ))
  )

;;; two
(progn
  (when t
    (let ((table (->> (aoc-data-as-lines )
                      (--map (aoc-s-split ":\\| " it))
                      (--reduce-from (progn
                                       (ht-set acc (car it) (cdr it))
                                       acc)
                                     (ht-create)))))
      (->> (aoc-expand-absolute table "root")
           (s-join "")
           (message)
           (kill-new)
           ))
    )
  )
