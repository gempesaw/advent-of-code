(require 'ht)

(defun aoc-move-segment (snake leader follower)
  (let ((headx (car (ht-get snake leader)))
        (heady (cadr (ht-get snake leader)))
        (tailx (car (ht-get snake follower)))
        (taily (cadr (ht-get snake follower))))
    (cond
     ;; same exact snake
     ((and (= headx tailx)
           (= heady taily)) snake)

     ;; diagonally one away
     ((and (= 1 (abs (- headx tailx)))
           (= 1 (abs (- heady taily)))) snake)

     ;; same row, different column, one away
     ((and (= headx tailx)
           (= 1 (abs (- heady taily)))) snake)

     ;; same row, different column, 2 away
     ((and (= headx tailx)
           (= 2 (abs (- heady taily))))
      (let ((increment (if (< heady taily)
                           -1
                         1)))
        (ht-set snake follower `(,tailx ,(+ taily increment)))
        snake))

     ;; same column, different row, 1 away
     ((and (= heady taily)
           (= 1 (abs (- headx tailx)))) snake)

     ((and (= heady taily)
           (= 2 (abs (- headx tailx))))
      (let ((increment (if (< headx tailx)
                           -1
                         1)))
        (ht-set snake follower `(,(+ tailx increment) ,taily))
        snake))


     (t (let ((x-increment (if (< headx tailx) -1 1))
              (y-increment (if (< heady taily) -1 1)))
          (ht-set snake follower `(,(+ tailx x-increment) ,(+ taily y-increment)))
          snake))
     )
    ))

(defun aoc-move-snake (snake)
  (let* ((keys (->> snake
                    (ht-keys)
                    (reverse)
                    (--filter (= (length it) 1)))))
    (->> keys
         (--map-indexed `(,it ,(nth (+ 1 it-index) keys)))
         (--filter (cadr it))
         (--reduce-from
          (aoc-move-segment acc (car it) (cadr it)) snake)
         )
    ))

(defun aoc-move (snake instruction)
  (let ((direction (car instruction))
        (amount (cadr instruction))
        (next-snake))

    (if (= 0 amount)
        snake
      (let ((head (ht-get snake "H")))
        (cond
         ((s-equals-p "R" direction) (ht-set snake "H" `(,(+ (car head) 1) ,(cadr head))))
         ((s-equals-p "L" direction) (ht-set snake "H" `(,(- (car head) 1) ,(cadr head))))
         ((s-equals-p "U" direction) (ht-set snake "H" `(,(car head) ,(+ (cadr head) 1))))
         ((s-equals-p "D" direction) (ht-set snake "H" `(,(car head) ,(- (cadr head) 1)))))
        (setq next-snake (aoc-move-snake snake))
        (push (->> snake
                   (ht-keys)
                   (reverse)
                   (--filter (= (length it) 1))
                   (--map (ht-get snake it)))
              (ht-get snake "history"))
        (aoc-move next-snake `(,direction ,(- amount 1)))))))

;; (reverse (ht-get (aoc-move (ht ("H" '(0 0))
;;                                ("1" '(0 0))
;;                                ("history" '()))
;;                            '("R" 2)) "history"))


"R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"

(--> (aoc-data-as-lines)
     (--map (s-split " " it ) it)
     (--map `(,(car it) ,(string-to-number (cadr it))) it)
     (-reduce-from
      (lambda (acc it) (aoc-move acc it))
      (ht ("H" '(0 0))
          ("1" '(0 0))
          ("2" '(0 0))
          ("3" '(0 0))
          ("4" '(0 0))
          ("5" '(0 0))
          ("6" '(0 0))
          ("7" '(0 0))
          ("8" '(0 0))
          ("9" '(0 0))
          ("history" '()))
      it)
     (ht-get it "history")
     (reverse it)
     (-map 'last it)
     (-distinct it)
     (length it)
     (number-to-string it)
     (kill-new it)

     )


;; ;;; one
;; (--> (aoc-data-as-lines)
;;      (--map (s-split " " it ) it)
;;      (--map `(,(car it) ,(string-to-number (cadr it))) it)
;;      (-reduce-from (lambda (acc it)
;;                      (aoc-move acc it))
;;                    (ht ("head x" 0)
;;                        ("head y" 0)
;;                        ("tail x" 0)
;;                        ("tail y" 0)
;;                        ("history" '())) it)
;;      (ht-get it "history")
;;      (--map `(,(caddr it) ,(cadddr it)) it)
;;      (-distinct it)
;;      (length it)
;;      (number-to-string it)
;;      (kill-new it))
