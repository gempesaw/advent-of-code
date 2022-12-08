(defun aoc-is-visible (x y row column)
  (cond ((= 0 x) 1)
        ((= 0 y) 1)
        ((= width (+ 1 x)) 1)
        ((= height (+ 1 y)) 1)
        ((--every (> (nth y column) it) (-take y column)) 1)
        ((--every (> (nth x row) it) (-take x row)) 1)
        ((--every (> (nth y column) it) (-take-last (- height y 1) column)) 1)
        ((--every (> (nth x row) it) (-take-last (- width x 1) row)) 1)
        (t 0)
        ))

(defun aoc-tally-visible (self candidates)
  (car (--reduce-from (cond ((= (cadr acc) 0) acc)
                            ((> self it) `(,(+ 1 (car acc)) 1))
                            ((<= self it) `(,(+ 1 (car acc)) 0))
                            (t acc))
                      '(0 1)
                      candidates)))

(defun aoc-scenic-score (x y row column)
  (aoc-tally-visible (nth x row) (-take-last (- width x 1) row))
  (cond ((= 0 x) 0)
        ((= 0 y) 0)
        ((= width (+ 1 x)) 0)
        ((= height (+ 1 y)) 0)
        (t (let ((up (aoc-tally-visible (nth y column) (reverse (-take y column))))
                 (left (aoc-tally-visible (nth x row) (reverse (-take x row))))
                 (right (aoc-tally-visible (nth x row) (-take-last (- width x 1) row)))
                 (down (aoc-tally-visible (nth y column) (-take-last (- height y 1) column))))
             (* up left right down))
           )))

(let* ((data "30373
25512
65332
33549
35390")
       (rows (->> data
                  (aoc-s-split "\n")
                  (--map (-map 'string-to-number (aoc-s-split "" it)))))
       (height (length rows))
       (width (length (car rows)))
       (columns (--map (-map (lambda (row) (nth it row)) rows) (number-sequence 0 (- width 1))))
       (visibility (-map-indexed (lambda (y row)
                                   (-map-indexed (lambda (x column)
                                                   (aoc-is-visible x y row column)) columns)) rows))
       )
  ;; (message "\n%s\n" (s-join "\n" (--map (s-join "" (-map 'number-to-string it)) visibility)))
  (-sum (-flatten visibility))
  )

;;; one
(let* ((data (f-read-text "data"))
       (rows (->> data
                  (aoc-s-split "\n")
                  (--map (-map 'string-to-number (aoc-s-split "" it)))))
       (height (length rows))
       (width (length (car rows)))
       (columns (--map (-map (lambda (row) (nth it row)) rows) (number-sequence 0 (- width 1))))
       (visibility (-map-indexed (lambda (y row)
                                   (-map-indexed (lambda (x column)
                                                   (aoc-is-visible x y row column)) columns)) rows))
       )
  (-sum (-flatten visibility))
  )

;;; two

(let* ((data (f-read-text "data"))
       (rows (->> data
                  (aoc-s-split "\n")
                  (--map (-map 'string-to-number (aoc-s-split "" it)))))
       (height (length rows))
       (width (length (car rows)))
       (columns (--map (-map (lambda (row) (nth it row)) rows) (number-sequence 0 (- width 1))))
       (scenic-score (-map-indexed (lambda (y row)
                                     (-map-indexed (lambda (x column)
                                                     (aoc-scenic-score x y row column)) columns)) rows))
       )

  (-max (-flatten scenic-score)))





;;; 30373
;;; 25512
;;; 65332
;;; 33549
;;; 35390
