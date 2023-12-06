;;; part 1
(->> (aoc-data-as-lines)
     (--map (--> it
                 (s-split ":\s+" it)
                 (cadr it)
                 (s-split " " it t)
                 (-map #'string-to-number it)
                 ))
     (apply #'-zip-lists)
     (--map (let ((time (car it))
                  (record-distance (cadr it)))
              (->> (number-sequence 1 (- time 1))
                   (--map (let* ((time-spent-holding-ship it)
                                 (time-spent-velocitying (- time time-spent-holding-ship))
                                 (distance-travelled (* time-spent-holding-ship time-spent-velocitying)))
                            ;; (message (format "hold: %s, velo time: %s, velo-distance: %s"
                            ;;                  time-spent-holding-ship
                            ;;                  time-spent-velocitying
                            ;;                  distance-travelled
                            ;;                  ))
                            (* time-spent-holding-ship time-spent-velocitying)
                            ))
                   (--filter (> it record-distance)))
              ))
     (-map #'length)
     (-product)
     )

(->> (aoc-data-as-lines)
     (--map (--> it
                 (s-split ":\s+" it)
                 (cadr it)
                 (s-replace " " "" it)
                 (string-to-number it)
                 ))
     (funcall (lambda (it)
                (let ((total-time (car it))
                      (record-distance (cadr it))
                      (candidate-time 0)
                      (winning nil))
                  (while (not winning)
                    (let* ((time-spent-holding-ship candidate-time)
                           (time-spent-velocitying (- total-time time-spent-holding-ship))
                           (distance-travelled (* time-spent-holding-ship time-spent-velocitying)))
                      ;; (message (format "hold: %s, velo time: %s, velo-distance: %s"
                      ;;                  time-spent-holding-ship
                      ;;                  time-spent-velocitying
                      ;;                  distance-travelled
                      ;;                  ))
                      (if (> distance-travelled record-distance)
                          (progn
                            (setq winning t)
                            (message (format "%s" candidate-time)))
                        (setq candidate-time (+ 1 candidate-time)))))
                  (+ (- total-time candidate-time candidate-time) 1)
                  )))

     )
