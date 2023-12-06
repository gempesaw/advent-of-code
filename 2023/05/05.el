(progn
  (defun aoc-d5-build-maps (data)
    (let ((table (ht-create))
          (lines (aoc-s-split "\n" data)))
      (ht-set! table "maps" '())
      (ht-set! table "current map" '())
      (->> lines
           (--reduce-from
            (cond
             ((s-match " map:" it)
              (progn
                (ht-set! acc "maps" (-snoc (ht-get acc "maps") (ht-get acc "current map")))
                (ht-set! acc "current map" '())
                acc)
              )
             ((s-match "^[0-9]+ [0-9]+ [0-9]+" it)
              (let* ((as-numbers (->> it
                                      (s-split " ")
                                      (-map #'string-to-number)))
                     (with-source-end (-snoc as-numbers (+ (nth 1 as-numbers)
                                                           (nth 2 as-numbers)))))
                (ht-set! acc "current map" (-snoc (ht-get acc "current map") with-source-end)))
              acc
              )
             (t acc))
            table
            )
           (funcall (lambda (table)
                      (-snoc (ht-get table "maps") (ht-get table "current map"))))
           (-non-nil))
      ))

  (defun aoc-d5-convert (map number)
    (let ((matching-range (->> map
                               (--first (let* ((destination-start (nth 0 it))
                                               (source-start (nth 1 it))
                                               (range (nth 2 it))
                                               (source-end (nth 3 it)))
                                          (and (<= number source-end)
                                               (>= number source-start))
                                          )))))
      ;; (message (format "map: %s, converting: %s, matching-range: %s" map number matching-range))
      (if matching-range
          (let ((result (--> number
                             (- it (nth 1 matching-range))
                             (+ it (nth 0 matching-range)))))
            ;; (message (format "%s" result))
            result)
        ;; (message (format "%s" number))
        number)))

  (defun aoc-d5-reverse (map number)
    (let ((matching-range (->> map
                               (--first (let* ((destination-start (nth 0 it))
                                               (source-start (nth 1 it))
                                               (range (nth 2 it))
                                               (destination-end (+ (nth 2 it) (nth 0 it))))
                                          (and (<= number destination-end)
                                               (>= number destination-start))
                                          )))))
      ;; (message (format "map: %s, converting: %s, matching-range: %s" map number matching-range))
      (if matching-range
          (let ((result (--> number
                             (+ it (nth 1 matching-range))
                             (- it (nth 0 matching-range)))))
            ;; (message (format "%s" result))
            result)
        ;; (message (format "%s" number))
        number)))

  (let* ((data (->> "data"
                    (f-read-text)
                    (s-chomp)))
         (seeds (->> data
                     (s-match "seeds: .*")
                     (car)
                     (s-split ": ")
                     (cadr)
                     (s-split " ")
                     (-map #'string-to-number)))
         (seeds-part-2 (->> seeds
                            (-partition 2)
                            (--map
                             (let ((start (nth 0 it) )
                                   (end (- (+ (nth 0 it) (nth 1 it)) 1)))
                               `(,start ,end))
                             )
                            (-flatten)
                            ))
         (maps (aoc-d5-build-maps data)))

    ;; part 1
    (->> seeds
         (-map
          (lambda (seed)
            (-reduce-from (lambda (acc map)
                            (aoc-d5-convert map acc)
                            ;; (let ((result (aoc-d5-convert map acc)))
                            ;;   (message (format "%s" result))
                            ;;   result)
                            )
                          seed
                          maps))
          )
         (-min)
         )


    ;; ran this starting at location 0, with big jumps of like 100000 until we
    ;; got to a location that corresponded to true values. then manually binary
    ;; search down to a closer spot
    (let ((location 79004050)
          (candidate)
          (found nil))
      (while (not found)
        (setq candidate (-reduce-from (lambda (acc map) (aoc-d5-reverse map acc))
                                      location
                                      (reverse maps)))
        (setq found (--reduce-from (or acc (and (<= candidate (nth 1 it))
                                                (>= candidate (nth 0 it))))
                                   found
                                   (-partition 2 seeds-part-2)
                                   ))

        (message (format "%s, %s, %s" location candidate found))

        (setq location (+ 1 location))))
    ))
