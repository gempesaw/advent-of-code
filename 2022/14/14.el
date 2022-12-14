(defun aoc-parse-rock-walls (vertices &optional wall-coordinates)
  (cond ((not vertices) wall-coordinates)
        ((not wall-coordinates) (aoc-parse-rock-walls (cdr vertices) `(,(car vertices))))
        (t (let* ((start (-last-item wall-coordinates))
                  (end (car vertices))
                  (wall-segment (cond ((= (car start) (car end)) (aoc-map-x start end))
                                      ((= (cadr start) (cadr end)) (aoc-map-y start end)))))
             (aoc-parse-rock-walls (cdr vertices) (append wall-coordinates wall-segment))) )
        )
  )

(defun aoc-map-x (start end)
  (let ((x (car start))
        (y (aoc-number-sequence (cadr start) (cadr end))))
    (--map `(,x ,it) y)))

(defun aoc-map-y (start end)
  (let ((x (aoc-number-sequence (car start) (car end)))
        (y (cadr start)))
    (--map `(,it ,y) x)))

(defun aoc-number-sequence (start end)
  (let ((args `(,start ,end)))
    (if (> start end)
        (reverse (apply 'number-sequence (reverse args)))
      (apply 'number-sequence args ))))

(setq aoc-sand-source '(500 0))
;;; crashes emacs when done recursively :(
;; (defun aoc-source-sand (sand current-sand walls &optional lowest-wall)
;;   (if (not lowest-wall)
;;       (setq lowest-wall (->> walls
;;                              (-map 'cadr)
;;                              (-max)) ))
;;   (let ((down `(,(+ (car current-sand) 0) ,(+ (cadr current-sand) 1)))
;;         (left `(,(+ (car current-sand) -1) ,(+ (cadr current-sand) 1)))
;;         (right `(,(+ (car current-sand) 1) ,(+ (cadr current-sand) 1))))
;;     (cond ((> (cadr current-sand) lowest-wall) sand)

;;           ((and (not (-contains-p walls down))
;;                 (not (-contains-p sand down)) (aoc-source-sand sand down walls lowest-wall)))
;;           ((and (not (-contains-p walls left))
;;                 (not (-contains-p sand left)) (aoc-source-sand sand left walls lowest-wall)))
;;           ((and (not (-contains-p walls right))
;;                 (not (-contains-p sand right)) (aoc-source-sand sand right walls lowest-wall)))

;;           (t ;; (aoc-sand-draw current-sand)
;;              (aoc-source-sand (append sand (list current-sand))
;;                               aoc-sand-source
;;                               walls)))))

(defun aoc-source-sand (sand current-sand walls)
  (let ((lowest-wall (->> walls
                          (-map 'cadr)
                          (-max))))
    ;; part 1
    ;; (loop-while (< (cadr current-sand) lowest-wall)

    (loop-while t
      (let ((down `(,(+ (car current-sand) 0) ,(+ (cadr current-sand) 1)))
            (left `(,(+ (car current-sand) -1) ,(+ (cadr current-sand) 1)))
            (right `(,(+ (car current-sand) 1) ,(+ (cadr current-sand) 1))))

        (aoc-sand-draw current-sand)
        (setq current-sand (cond ((and (not (-contains-p walls down))
                                       (not (-contains-p sand down)) down))
                                 ((and (not (-contains-p walls left))
                                       (not (-contains-p sand left)) left))
                                 ((and (not (-contains-p walls right))
                                       (not (-contains-p sand right)) right))
                                 (t (setq sand (append sand (list current-sand)))
                                    (if (-same-items-p current-sand aoc-sand-source)
                                        (loop-break))
                                    aoc-sand-source)))))
    sand))

(defun aoc-sand-draw-background (walls)
  (with-current-buffer (get-buffer-create "*draw*")
    (erase-buffer)
    (loop-for-each y ys
      (loop-for-each x xs
        (cond ((-contains-p walls `(,x ,y)) (insert "#"))
              (t (insert "."))))
      (insert "\n"))))

(defun aoc-sand-draw (sand)
  (with-current-buffer (get-buffer-create "*draw*")
    (goto-char 1)
    (forward-line (cadr sand))
    (forward-char (- (car sand) min-x))
    (delete-region (point) (+ (point) 1))
    (insert "o")
    (sit-for 0)))

;;; sample
;; (->> "498,4 -> 498,6 -> 496,6
;; 503,4 -> 502,4 -> 502,9 -> 494,9"
;;      (aoc-s-split "\n")
;;      (-map (lambda (line)
;;              (->> line
;;                   (s-split " -> ")
;;                   (--map (-map 'string-to-number (s-split "," it))))))
;;      (-map 'aoc-parse-rock-walls)
;;      (-map '-distinct)
;;      (-flatten-n 1)
;;      (aoc-source-sand '() aoc-sand-source)
;;      (--map (format "%s" it))
;;      (s-join "\n")
;;      ;; (length)
;;      )

;;; one
(let* (;; (max-specpdl-size 100000)
       ;; (max-lisp-eval-depth 100000)
       (walls (->> (aoc-data-as-lines)
                   ;; "498,4 -> 498,6 -> 496,6
                   ;;     503,4 -> 502,4 -> 502,9 -> 494,9"
                   ;; (aoc-s-split "\n")
                   (-map (lambda (line)
                           (->> line
                                (s-split " -> ")
                                (--map (-map 'string-to-number (s-split "," it))))))
                   (-map 'aoc-parse-rock-walls)
                   (-map '-distinct)
                   (-flatten-n 1)))
       )
  (setq min-x (- (->> walls
                      (-map 'car)
                      (-min)) 1))
  (setq max-x (+ 1 (->> walls
                        (-map 'car)
                        (-max))))
  (setq min-y 0)
  (setq max-y (+ 1 (->> walls
                        (-map 'cadr)
                        (-max))))

  (setq xs (number-sequence min-x max-x))
  (setq ys (number-sequence min-y max-y))
  (aoc-sand-draw-background walls)
  ;; (length (aoc-source-sand '() aoc-sand-source walls))
  )

;;; two
(let* (;; (max-specpdl-size 100000)
       ;; (max-lisp-eval-depth 100000)
       (walls (->> (aoc-data-as-lines)
                   ;; "498,4 -> 498,6 -> 496,6
                   ;;         503,4 -> 502,4 -> 502,9 -> 494,9"
                   ;; (aoc-s-split "\n")
                   (-map (lambda (line)
                           (->> line
                                (s-split " -> ")
                                (--map (-map 'string-to-number (s-split "," it))))))
                   (-map 'aoc-parse-rock-walls)
                   (-map '-distinct)
                   (-flatten-n 1)))
       )
  (setq min-x (- (->> walls
                      (-map 'car)
                      (-min)) 1))
  (setq max-x (+ 1 (->> walls
                        (-map 'car)
                        (-max))))
  (setq min-y 0)
  (setq max-y (+ 2 (->> walls
                        (-map 'cadr)
                        (-max))))
  (setq xs (number-sequence min-x max-x))
  (setq ys (number-sequence min-y max-y))

  (setq floor (aoc-parse-rock-walls `((,(- min-x max-y) ,max-y) (,(+ max-x max-y) ,max-y))))
  (setq walls (append walls floor))

  ;; recalculate the dimensions  for the drawing
  (setq min-x (- (->> walls
                      (-map 'car)
                      (-min)) 1))
  (setq max-x (+ 1 (->> walls
                        (-map 'car)
                        (-max))))
  (setq min-y 0)
  (setq max-y (+ 2 (->> walls
                        (-map 'cadr)
                        (-max))))
  (setq xs (number-sequence min-x max-x))
  (setq ys (number-sequence min-y max-y))
  (aoc-sand-draw-background walls)

  (setq osand (aoc-source-sand '() aoc-sand-source walls))
  ;; (setq awooga-length (length osand ))
  )
