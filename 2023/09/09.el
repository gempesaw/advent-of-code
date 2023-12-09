(progn
  (defun aoc-d9-diff-sequence (sequence)
    (let ((current-sequence sequence)
          (history))
      (while (not (--every (eq 0 it) current-sequence))
        (push current-sequence history)
        (setq current-sequence (->> current-sequence
                                    (-partition-in-steps 2 1)
                                    (--map (- (cadr it) (car it))))))
      history
      )
    )

  (defun aoc-d9-predict (history)
    (->> history
         (--map-indexed (let ((new-item (if (eq it-index 0)
                                            (car it)
                                          (+ (-last-item it) (-last-item (nth (- it-index 1) history))))))
                          (setq it (nreverse it))
                          (push new-item it)
                          (setq it (nreverse it)))
                        )))

  (defun aoc-d9-predict-backwards (history)
    (-dotimes (length history)
      (lambda (it-index)
        (let ((new-item (if (eq it-index 0)
                            (car (nth it-index history))
                          (- (car (nth it-index history)) (car (nth (- it-index 1) history))))))
          (push new-item (nth it-index history)))))
    history)


  ;; part 1
  (->> (aoc-data-as-lines)
       (--map (->>(s-split " " it t)
                  (-map #'string-to-number)))
       (-map #'aoc-d9-diff-sequence)
       (-map #'aoc-d9-predict)
       (-map #'-last-item)
       (-map #'-last-item)
       (-sum))

  ;; part 2
  (->> (aoc-data-as-lines)
       (--map (->>(s-split " " it t)
                  (-map #'string-to-number)))
       (-map #'aoc-d9-diff-sequence)
       (-map #'aoc-d9-predict-backwards)
       (-map #'-last-item)
       (-map #'car)
       (-sum))
  )
