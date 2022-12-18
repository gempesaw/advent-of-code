(defun aoc-coords-to-faces (coords-string)
  (cl-destructuring-bind (x1 y1 z1) (->> coords-string
                                         (aoc-s-split ",")
                                         (-map 'string-to-number))
    (let ((x0 (- x1 1))
          (y0 (- y1 1))
          (z0 (- z1 1)))

      `(
        ((,x0 ,y0 ,z0) (,x0 ,y1 ,z0) (,x0 ,y0 ,z1) (,x0 ,y1 ,z1))

        ((,x0 ,y0 ,z0) (,x0 ,y1 ,z0) (,x1 ,y0 ,z0) (,x1 ,y1 ,z0))

        ((,x0 ,y0 ,z0) (,x0 ,y0 ,z1) (,x1 ,y0 ,z0) (,x1 ,y0 ,z1))

        ((,x0 ,y0 ,z1) (,x0 ,y1 ,z1) (,x1 ,y0 ,z1) (,x1 ,y1 ,z1))

        ((,x0 ,y1 ,z0) (,x0 ,y1 ,z1) (,x1 ,y1 ,z0) (,x1 ,y1 ,z1))

        ((,x1 ,y0 ,z0) (,x1 ,y1 ,z0) (,x1 ,y0 ,z1) (,x1 ,y1 ,z1))

        )

      )))

;;; one
(when nil
  (let ((faces (ht-create))
        (facepoints (->> ;; "2,2,2
                     ;; 1,2,2
                     ;; 3,2,2
                     ;; 2,1,2
                     ;; 2,3,2
                     ;; 2,2,1
                     ;; 2,2,3
                     ;; 2,2,4
                     ;; 2,2,6
                     ;; 1,2,5
                     ;; 3,2,5
                     ;; 2,1,5
                     ;; 2,3,5"
                     (f-read "data")
                     (s-chomp)
                     (aoc-s-split "\n")
                     (-map 'aoc-coords-to-faces)
                     (-flatten-n 1))))
    (--each facepoints (let ((key (format "%s" it))) (ht-set faces key (+ 1 (ht-get faces key 0)))))
    (->> faces
         (ht-values)
         (--filter (eq 1 it))
         (-sum))
    ))

;;; two

;;; giveup
(defun aoc-is-excluded-cube (point faces)
  (let ((facepoints (aoc-coords-to-faces (car points-to-check))))
    (--each facepoints (let ((key (format "%s" it))) (ht-set faces key (+ 1 (ht-get faces key 0)))))
    (->> faces
         (ht-items)
         (--filter (eq 3 (cadr it))))))
(let* ((faces (ht-create))
       (points (->> (f-read "data")
                    (s-chomp)
                    (aoc-s-split "\n")))
       (facepoints (->> ;; "2,2,2
                    ;; 1,2,2
                    ;; 3,2,2
                    ;; 2,1,2
                    ;; 2,3,2
                    ;; 2,2,1
                    ;; 2,2,3
                    ;; 2,2,4
                    ;; 2,2,6
                    ;; 1,2,5
                    ;; 3,2,5
                    ;; 2,1,5
                    ;; 2,3,5"
                    points
                    (-map 'aoc-coords-to-faces)
                    (-flatten-n 1)))
       (doubled-faces)
       (doubled-face-points (ht-create)))
  (--each facepoints (let ((key (format "%s" it))) (ht-set faces key (+ 1 (ht-get faces key 0)))))
  (setq doubled-faces (->> faces
                           (ht-items)
                           (--filter (eq 2 (cadr it)))
                           (--map (eval (car (read-from-string (format "'%s" (car it))))))))


  (--each (->> doubled-faces (-flatten-n 1))
    (let ((key (format "%s" it))) (ht-set doubled-face-points key (+ 1 (ht-get doubled-face-points key 0)))))

  (setq points-to-check (->> doubled-face-points
                             (ht-items)
                             (--filter (>= (cadr it) 3))
                             (-map 'car)
                             (--map (->> it
                                         (s-replace "(" "")
                                         (s-replace ")" "")
                                         (s-replace " " ",")))
                             (funcall (lambda (dfp) (-difference dfp points)))))




  )
