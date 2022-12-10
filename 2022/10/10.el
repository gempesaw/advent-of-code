(defun aoc-do-line (state line)
  (let ((instruction (car (s-split " " line)))
        (amount (cadr (s-split " " line)))
        (cycle (ht-get state "cycle"))
        (x (ht-get state "x")))
    (cond
     ((s-equals-p instruction "noop") (aoc-increment-cycle state))
     ((s-equals-p instruction "addx")
      (let ((new-state (aoc-increment-cycle (aoc-increment-cycle state))))
        (ht-set new-state "x" (+ (string-to-number amount) x))
        new-state)))))

(defun aoc-increment-cycle (state)
  (ht-set state "cycle" (+ 1 (ht-get state "cycle")))
  (let ((cycle (ht-get state "cycle"))
        (key-cycles '(20 60 100 140 180 220))
        (x (ht-get state "x")))
    (when (memq cycle key-cycles)
      (ht-set state cycle x))
    (aoc-draw-row state)))

(defun aoc-draw-row (state)
  (let* ((cycle (ht-get state "cycle"))
         (x (ht-get state "x"))
         (row (ht-get state "row"))
         (position (- (mod cycle 40) 1))
         (within-three-p (<= (abs (- x position )) 1))
         (pixel (if within-three-p "#" ".")))
    (ht-set state "row" (format "%s%s" row pixel))
    state))



(->> (aoc-data-as-lines)
     (--reduce-from (aoc-do-line acc it) (ht ("cycle" 0)
                                             ("x" 1)
                                             ("row" "")))

     (gethash "row")
     (aoc-s-split "")
     (-partition 40)
     (--map (s-join "" it))
     (s-join "\n")
     (insert)
     )

;;;
;; ###..#....###...##..####.###...##..#...#
;; #..#.#....#..#.#..#.#....#..#.#..#.#....
;; #..#.#....#..#.#..#.###..###..#....#....
;; ###..#....###..####.#....#..#.#....#....
;; #....#....#....#..#.#....#..#.#..#.#....
;; #....####.#....#..#.#....###...##..####.
