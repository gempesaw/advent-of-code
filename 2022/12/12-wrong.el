(progn
  (defun aoc-map-parse-start-end (map)
    (let ((start (->> map
                      (--map-indexed `(,(-elem-index "S" it) ,it-index))
                      (--filter (and (car it) (cadr it)) )
                      (car)))
          (end (->> map
                    (--map-indexed `(,(-elem-index "E" it) ,it-index))
                    (--filter (and (car it) (cadr it)) )
                    (car))))
      (ht ("start" start)
          ("end" end)
          ("map" map)
          ("history" `(,start)))))

  (defun aoc-map-get-value (coordinate map)
    (let* ((x (car coordinate))
           (y (cadr coordinate))
           (letter-at-coordinate (when (and x y) (nth x (nth y map)))))
      (when (and letter-at-coordinate
                 (>= x 0)
                 (>= y 0))
        (cond
         ((s-equals-p "S" letter-at-coordinate) (string-to-char "a"))
         ((s-equals-p "E" letter-at-coordinate) (+ 1 (string-to-char "z")))
         (letter-at-coordinate (string-to-char letter-at-coordinate))))))


  (defun aoc-map-find-moves (state)
    (let* ((position (-last-item (ht-get state "history")))
           (map (ht-get state "map"))
           (end (ht-get state "end"))
           (current-value (aoc-map-get-value position map))
           (candidates (->> '((-1 0) (1 0) (0 1) (0 -1))
                            (--map (-list (+ (car position) (car it)) (+ (cadr position) (cadr it))))
                            (--map (append it
                                           (-list (aoc-map-get-value it map)
                                                  (sqrt (+ (expt (- (car end) (car it)) 2)
                                                           (expt (- (cadr end) (cadr it)) 2))))))
                            (--filter (and (caddr it)
                                           (<= (caddr it) (+ 1  current-value))))
                            (--sort (< (-last-item it) (-last-item other)))
                            )))
      candidates))

  (defun aoc-map-move (state &optional history-key)
    (let* ((moves (aoc-map-find-moves state))
           (history-key (if history-key history-key "history"))
           (history (ht-get state history-key))
           (position (-last-item history))
           (current-value (aoc-map-get-value position (ht-get state "map")))
           (chosen-moves (->> moves
                              ;; (--map (progn (message (format "%s %s %s" (not (< (nth 2 it) current-value)) (nth 2 it) current-value)) it))
                              (--map (-take 2 it))
                              (--filter (not (-contains-p history it)))
                              (-take 2)))
           (end (ht-get state "end"))
           (chosen-move))
      (if (-same-items-p position end)
          state
        (if (< (nth 2 (car moves)) current-value)
            (-each (cdr chosen-moves) (lambda (move)
                                        (let ((new-history-key (format "%s,%s" (car move) (cadr move))))
                                          (ht-set state new-history-key (append (ht-get state history-key) `(,move)))
                                          (aoc-map-move state new-history-key))))
          (ht-set state history-key (append (ht-get state history-key) `(,(car chosen-moves))))
          (aoc-map-move state history-key)))
      state
      ))

  ;; (->> "Sabqponm
  ;; abcryxxl
  ;; accszExk
  ;; acctuvwj
  ;; abdefghi"
  ;;        (aoc-s-split "\n")
  ;;        (--map (aoc-s-split "" it))
  ;;        (aoc-map-parse-start-end)
  ;;        (aoc-map-move)
  ;;        (gethash "history")
  ;;        (length)
  ;;        ;; (--map (format "(%s, %s)" (car it) (cadr it)))
  ;;        ;; (s-join "\n")
  ;;        )


  (->> (f-read "data")
       (aoc-s-split "\n")
       (--map (aoc-s-split "" it))
       (aoc-map-parse-start-end)
       (aoc-map-move)
       (gethash "20,21")
       (--map (format "(%s, %s)" (car it) (cadr it)))
       (s-join "\n")
       ))
