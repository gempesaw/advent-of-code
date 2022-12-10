(require 'ht)

(progn
  (defun aoc-move (position instruction)
    (let ((direction (car instruction))
          (amount (cadr instruction))
          (next-position))


      (if (= 0 amount)
          position
        (cond
         ((s-equals-p "R" direction) (ht-set position "head x" (+ (ht-get position "head x") 1)))
         ((s-equals-p "L" direction) (ht-set position "head x" (- (ht-get position "head x") 1)))
         ((s-equals-p "U" direction) (ht-set position "head y" (+ (ht-get position "head y") 1)))
         ((s-equals-p "D" direction) (ht-set position "head y" (- (ht-get position "head y") 1))))
        (setq next-position (aoc-move-tail position))
        (push `(,(ht-get next-position "head x") ,(ht-get next-position "head y")
                ,(ht-get next-position "tail x") ,(ht-get next-position "tail y")) (ht-get next-position "history"))
        (aoc-move next-position `(,direction ,(- amount 1))))))

  (defun aoc-move-tail (position)
    (let ((headx (ht-get position "head x"))
          (heady (ht-get position "head y"))
          (tailx (ht-get position "tail x"))
          (taily (ht-get position "tail y")))
      (cond
       ;; same exact position
       ((and (= headx tailx)
             (= heady taily)) position)

       ;; diagonally one away
       ((and (= 1 (abs (- headx tailx)))
             (= 1 (abs (- heady taily)))) position)

       ;; same row, different column, one away
       ((and (= headx tailx)
             (= 1 (abs (- heady taily)))) position)

       ;; same row, different column, 2 away
       ((and (= headx tailx)
             (= 2 (abs (- heady taily))))
        (let ((increment (if (< heady taily)
                             -1
                           1)))
          (ht-set position "tail y" (+ taily increment))
          position))

       ;; same column, different row, 1 away
       ((and (= heady taily)
             (= 1 (abs (- headx tailx)))) position)

       ((and (= heady taily)
             (= 2 (abs (- headx tailx))))
        (let ((increment (if (< headx tailx)
                             -1
                           1)))
          (ht-set position "tail x" (+ tailx increment))
          position))



       (t (let ((x-increment (if (< headx tailx) -1 1))
                (y-increment (if (< heady taily) -1 1)))
            (ht-set position "tail x" (+ tailx x-increment))
            (ht-set position "tail y" (+ taily y-increment))
            position))
       )
      ))


  (defun aoc-positions-to-moves (positions &optional moves)
    (let ((here (car positions))
          (next (cadr positions))
          (rest (cdr positions))
          (movelist (if moves moves '())))
      (if (not next)
          movelist
        (cond
         ((< (car here) (car next)) (push '("R" 1) movelist))
         ((> (car here) (car next)) (push '("L" 1) movelist))
         ((< (cadr here) (cadr next)) (push '("U" 1) movelist))
         ((> (car here) (car next)) (push '("D" 1) movelist))
         )
        (aoc-positions-to-moves rest movelist))))

  (defun aoc-get-tail-positions (moves)
    (--> moves
         (ht-get it "history")
         (--map `(,(caddr it) ,(cadddr it)) it)
         (reverse it)
         (aoc-positions-to-moves it)))

  ;; (aoc-follow (ht ("head x" 0)
  ;;                 ("head y" 0)
  ;;                 ("tail x" 0)
  ;;                 ("tail y" 0)
  ;;                 ("history" '()))
  ;;             '((1 0)))
  )


(--> "R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"
     (aoc-s-split "\n" it)
     (--map (s-split " " it ) it)
     (--map `(,(car it) ,(string-to-number (cadr it))) it)
     (-reduce-from (lambda (acc it)
                     (aoc-move acc it))
                   (ht ("head x" 0)
                       ("head y" 0)
                       ("tail x" 0)
                       ("tail y" 0)
                       ("history" '())) it)
     (aoc-get-tail-positions it)
     (reverse it)
     )


;;; one
(--> (aoc-data-as-lines)
     (--map (s-split " " it ) it)
     (--map `(,(car it) ,(string-to-number (cadr it))) it)
     (-reduce-from (lambda (acc it)
                     (aoc-move acc it))
                   (ht ("head x" 0)
                       ("head y" 0)
                       ("tail x" 0)
                       ("tail y" 0)
                       ("history" '())) it)
     (ht-get it "history")
     (--map `(,(caddr it) ,(cadddr it)) it)
     (-distinct it)
     (length it)
     (number-to-string it)
     (kill-new it))
