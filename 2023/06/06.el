;; ;;; part 1
;; (->> (aoc-data-as-lines)
;;      (--map (--> it
;;                  (s-split ":\s+" it)
;;                  (cadr it)
;;                  (s-split " " it t)
;;                  (-map #'string-to-number it)
;;                  ))
;;      (apply #'-zip-lists)
;;      (--map (let ((time (car it))
;;                   (record-distance (cadr it)))
;;               (->> (number-sequence 1 (- time 1))
;;                    (--map (let* ((time-spent-holding-ship it)
;;                                  (time-spent-velocitying (- time time-spent-holding-ship))
;;                                  (distance-travelled (* time-spent-holding-ship time-spent-velocitying)))
;;                             ;; (message (format "hold: %s, velo time: %s, velo-distance: %s"
;;                             ;;                  time-spent-holding-ship
;;                             ;;                  time-spent-velocitying
;;                             ;;                  distance-travelled
;;                             ;;                  ))
;;                             (* time-spent-holding-ship time-spent-velocitying)
;;                             ))
;;                    (--filter (> it record-distance)))
;;               ))
;;      (-map #'length)
;;      (-product)
;;      )

(->> (aoc-data-as-lines)
     (--map (--> it
                 (s-split ":\s+" it)
                 (cadr it)
                 (s-split " " it t)
                 (-map #'string-to-number it)
                 ))
     ;; (apply #'-zip-lists)
     ;; (--map (let ((time (car it))
     ;;              (record-distance (cadr it)))
     ;;          (->> (number-sequence 1 (- time 1))
     ;;               (--map (let* ((time-spent-holding-ship it)
     ;;                             (time-spent-velocitying (- time time-spent-holding-ship))
     ;;                             (distance-travelled (* time-spent-holding-ship time-spent-velocitying)))
     ;;                        ;; (message (format "hold: %s, velo time: %s, velo-distance: %s"
     ;;                        ;;                  time-spent-holding-ship
     ;;                        ;;                  time-spent-velocitying
     ;;                        ;;                  distance-travelled
     ;;                        ;;                  ))
     ;;                        (* time-spent-holding-ship time-spent-velocitying)
     ;;                        ))
     ;;               (--filter (> it record-distance)))
     ;;          ))
     ;; (-map #'length)
     ;; (-product)
     )
