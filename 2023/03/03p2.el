(let* ((grid (->> (aoc-data-as-lines)
                  (--map (->> (s-split "" it t)))))
       (size (->> grid
                  (car)
                  (length))))

  (defun aoc-d3-is-symbol (point)
    (let ((value (aoc-d3-xy point)))
      (setq result (if (integerp value)
                       nil
                     (not (or (s-match "[0-9]" value)
                              (s-equals? "." value)))))
      result))

  (defun aoc-d3-find-symbols (grid)
    (let ((symbols))
      (-dotimes size
        (lambda (row)
          (-dotimes size
            (lambda (column)
              (let ((point `(,row ,column )))
                (when (aoc-d3-is-symbol point)
                  (setq symbols (append symbols `(,point))))))
            )))
      symbols))

  (defun aoc-d3-points-to-check (point)
    (->> '((-1 -1)
           (-1 0)
           (-1 1)
           (0 -1)
           (0 1)
           (1 -1)
           (1 0)
           (1 1))
         (--map `(,(+ (nth 0 it) (nth 0 point))
                  ,(+ (nth 1 it) (nth 1 point))))))

  (defun aoc-d3-xy (point)
    (let ((value (ignore-errors (nth (nth 0 point) (nth (nth 1 point) grid)))))
      (if value
          value
        ".")))

  (defun aoc-d3-find-number-including-point (point value)
    (let* ((row (nth 1 point))
           (column (nth 0 point))
           (row-split-at-column (-split-at column (nth row grid)))
           (before-digits (->> (car row-split-at-column)
                               (reverse)
                               (s-join "")
                               (s-match "^[0-9]+")
                               (car)
                               (s-reverse)))
           (after-digits (->> (cadr row-split-at-column)
                              (s-join "")
                              (s-match "^[0-9]+")
                              (car)))
           )
      (format "%s%s" before-digits after-digits)
      ))

  (defun aoc-d3-find-adjacent-numbers (point)
    (->> point
         (aoc-d3-points-to-check)
         (--map
          (let* ((value (aoc-d3-xy it)))
            (cond
             ((s-equals? "." value) nil)
             ((s-match "[0-9]" value) (aoc-d3-find-number-including-point it value))
             (t nil))
            )
          )
         (-non-nil)
         (-uniq)))

  (->> grid
       (aoc-d3-find-symbols)
       (-map #'aoc-d3-find-adjacent-numbers)
       (--filter (eq 2 (length it)))
       (--map (-product (-map #'string-to-number it)))
       (-sum)))
