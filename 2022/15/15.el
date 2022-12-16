(defun aoc-find-no-beacons (target-row x y distance)
  (let ((min-y (- y distance))
        (max-y (+ y distance)))
    (if (or (< target-row min-y)
            (> target-row max-y))
        (progn
          ;; (message (format "skipping: %s < %s < %s" min-y target-row max-y))
          (sit-for 0)
          nil)
      (let ((min-x (- x distance))
            (max-x (+ x distance))
            (points))
        (setq points (->> (number-sequence min-y max-y)
                          (--map `(,it ,(- distance (abs (- y it)))))
                          (--filter (= target-row (car it)))
                          (--map (apply 'aoc-generate-points x it))))
        ;; (message (format "found points for sensor at (%s, %s): %s" x y (length (car points))))
        (sit-for 0)
        points))))

(defun aoc-generate-points (x y distance)
  (let ((xs (number-sequence (* -1 distance) distance)))
    (--map `(,(+ x it) ,y) xs)))


;; 5 < 10 < 15
;; min-y < target-row < max-y

;; target-row < min-y

;; target-row > max-y


(defun aoc-parse-points (line)
  (->> line
       (s-match "x=\\(.+\\), y=\\(.+\\):.*x=\\(.+\\), y=\\(.+\\)")
       (cdr)
       (-map 'string-to-number)))

(defun aoc-manhattan (x1 y1 x2 y2)
  `(,x1 ,y1 ,(+ (abs (- x2 x1)) (abs (- y2 y1)))))

;;; sample
;; (let* ((bounds 20)
;;        (target-rows (number-sequence 0 bounds))
;;        (points))
;;   (loop-for-each target-row target-rows
;;     (setq points (->> "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
;; Sensor at x=9, y=16: closest beacon is at x=10, y=16
;; Sensor at x=13, y=2: closest beacon is at x=15, y=3
;; Sensor at x=12, y=14: closest beacon is at x=10, y=16
;; Sensor at x=10, y=20: closest beacon is at x=10, y=16
;; Sensor at x=14, y=17: closest beacon is at x=10, y=16
;; Sensor at x=8, y=7: closest beacon is at x=2, y=10
;; Sensor at x=2, y=0: closest beacon is at x=2, y=10
;; Sensor at x=0, y=11: closest beacon is at x=2, y=10
;; Sensor at x=20, y=14: closest beacon is at x=25, y=17
;; Sensor at x=17, y=20: closest beacon is at x=21, y=22
;; Sensor at x=16, y=7: closest beacon is at x=15, y=3
;; Sensor at x=14, y=3: closest beacon is at x=15, y=3
;; Sensor at x=20, y=1: closest beacon is at x=15, y=3"
;;                       (aoc-s-split "\n")
;;                       (-map 'aoc-parse-points)
;;                       (--map (apply 'aoc-manhattan it))
;;                       (--map (apply 'aoc-find-no-beacons target-row it))
;;                       (-non-nil)
;;                       (-flatten-n 2)
;;                       (-distinct)
;;                       (--reject (or (> 0 (car it))
;;                                     (> 0 (cadr it))
;;                                     (< bounds (car it))
;;                                     (< bounds (cadr it))))

;;                       ))
;;     (setq excluded-points-count (length points))
;;     (message "row %s has excluded points: %s" target-row excluded-points-count)
;;     (when (eq excluded-points-count bounds)
;;       (message (format "(%s,%s)"
;;                        (->> points
;;                             (-map 'car)
;;                             (-sum)
;;                             (- (-sum (number-sequence 0 bounds))))
;;                        target-row)))))


;;; one
;; (let ((target-row 2000000)
;;       (beacons))
;;   (->> (aoc-data-as-lines)
;;        (-map 'aoc-parse-points)
;;        (--map (progn
;;                 (push (-take-last 2 it) beacons)
;;                 it))
;;        (--map (apply 'aoc-manhattan it))
;;        (--map (apply 'aoc-find-no-beacons target-row it))
;;        (-non-nil)
;;        (-flatten-n 2)
;;        (-distinct)
;;        (--remove (-contains-p beacons it))
;;        (length)
;;        ;; (--sort (< (car it) (car other)))
;;        ;; (--map (format "%s,%s" (car it) (cadr it)))
;;        ;; (s-join "\n")
;;        )
;;   )


;;; two
(let ((beacons)
      (sensors
       (->> (aoc-data-as-lines)
            ;; "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
            ;;     Sensor at x=9, y=16: closest beacon is at x=10, y=16
            ;;     Sensor at x=13, y=2: closest beacon is at x=15, y=3
            ;;     Sensor at x=12, y=14: closest beacon is at x=10, y=16
            ;;     Sensor at x=10, y=20: closest beacon is at x=10, y=16
            ;;     Sensor at x=14, y=17: closest beacon is at x=10, y=16
            ;;     Sensor at x=8, y=7: closest beacon is at x=2, y=10
            ;;     Sensor at x=2, y=0: closest beacon is at x=2, y=10
            ;;     Sensor at x=0, y=11: closest beacon is at x=2, y=10
            ;;     Sensor at x=20, y=14: closest beacon is at x=25, y=17
            ;;     Sensor at x=17, y=20: closest beacon is at x=21, y=22
            ;;     Sensor at x=16, y=7: closest beacon is at x=15, y=3
            ;;     Sensor at x=14, y=3: closest beacon is at x=15, y=3
            ;;     Sensor at x=20, y=1: closest beacon is at x=15, y=3"
            ;; (aoc-s-split "\n")
            (-map 'aoc-parse-points)
            (--map (apply 'aoc-manhattan it)))))

  (defun aoc-manhattan-border-points (x y distance)
    (let ((border (+ 1 distance))
          (bounds 4000000))
      (->> (number-sequence (* -1 border) border)
           (--map (let ((px (+ x it))
                        (up-y (+ y (- border (abs it))))
                        (down-y (- y (- border (abs it)))))
                    (when (and (< 0 px) (< px bounds))
                      (->> `((,px ,up-y) (,px ,down-y))
                           (--filter (and (< 0 (cadr it)) (< (cadr it) bounds)))
                           (-distinct)))))
           (-flatten-n 1))))

  (defun aoc-check-included (sensor point)
    (let* ((distance (-last-item (aoc-manhattan (car sensor) (cadr sensor) (car point) (cadr point))))
           (inside-p (< distance (-last-item sensor))))
      inside-p))

  (loop-for-each s sensors
    (message (format "checking %s" s))
    (sit-for 0)
    (loop-for-each p (apply 'aoc-manhattan-border-points s)
      (let ((inclusions (->> (--map (aoc-check-included it p) sensors)
                             (-non-nil)
                             (length))))
        (when (eq 0 inclusions)
          (message (format "%s %s" inclusions p))
          (loop-break)
          (loop-break)
          (loop-break)
          (loop-break)))
      )
    (message (format "finished %s" s))
    (sit-for 0)))


;;; (2949122 3041245)
