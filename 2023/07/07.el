;;; part 1
(let ((label-lookup (ht<-plist '("A" 14
                                 "K" 13
                                 "Q" 12
                                 "J" 11
                                 "T" 10
                                 "9" 9
                                 "8" 8
                                 "7" 7
                                 "6" 6
                                 "5" 5
                                 "4" 4
                                 "3" 3
                                 "2" 2)))
      ordered)

  (defun aoc-d7-compare (left right)
    (aoc-d7-compare-hands (s-split "" (ht-get left 'string) t)
                          (s-split "" (ht-get right 'string) t)))

  (defun aoc-d7-compare-hands (left right)
    (let ((leftcar (ht-get label-lookup (car left)))
          (rightcar (ht-get label-lookup (car right))))
      (if (eq leftcar rightcar)
          (aoc-d7-compare-hands (cdr left) (cdr right))
        (< leftcar rightcar))))

  (->> (aoc-data-as-lines)
       (--map (let* ((pieces (s-split " " it))
                     (string (car pieces))
                     (hand (--reduce-from (progn
                                            (ht-update-with! acc it #'1+ 0)
                                            acc)
                                          (ht-create)
                                          (s-split "" string t)))
                     (unique (length (ht-keys hand)))
                     (counts (sort (ht-values hand) '<))
                     (bid (->> pieces (cadr) (string-to-number)))
                     (table (ht-create)))

                (ht-set table 'string string)
                (ht-set table 'hand hand)
                (ht-set table 'bid bid)
                (ht-set table 'unique unique)
                (ht-set table 'type (cond
                                     ((eq unique 1) 7)

                                     ((and (eq unique 2)
                                           (equal '(1 4) counts)) 6)

                                     ((and (eq unique 2)
                                           (equal '(2 3) counts)) 5)

                                     ((and (eq unique 3)
                                           (equal '(1 1 3) counts)) 4)

                                     ((and (eq unique 3)
                                           (equal '(1 2 2) counts)) 3)

                                     ((and (eq unique 4)
                                           (equal '(1 1 1 2) counts)) 2)

                                     ((eq unique 5) 1)
                                     ))

                table
                ))
       (--group-by (ht-get it 'type))
       (--sort (< (car it) (car other)))
       (--map (-sort #'aoc-d7-compare (cdr it)))
       (-flatten)
       (--map-indexed (* (ht-get it 'bid) (+ 1 it-index)))
       (-sum)
       ))

;;; part 2
(let ((label-lookup (ht<-plist '("A" 14
                                 "K" 13
                                 "Q" 12
                                 "T" 10
                                 "9" 9
                                 "8" 8
                                 "7" 7
                                 "6" 6
                                 "5" 5
                                 "4" 4
                                 "3" 3
                                 "2" 2
                                 "J" 1)))
      ordered)

  (defun aoc-d7-compare (left right)
    (aoc-d7-compare-hands (s-split "" (ht-get left 'string) t)
                          (s-split "" (ht-get right 'string) t)))

  (defun aoc-d7-compare-hands (left right)
    (let ((leftcar (ht-get label-lookup (car left)))
          (rightcar (ht-get label-lookup (car right))))
      (if (eq leftcar rightcar)
          (aoc-d7-compare-hands (cdr left) (cdr right))
        (< leftcar rightcar))))

  (->> (aoc-data-as-lines)
       (--map (let* ((pieces (s-split " " it))
                     (string (car pieces))
                     (jokers (s-count-matches "J" (car pieces)))
                     (hand (--reduce-from (progn
                                            (ht-update-with! acc it #'1+ 0)
                                            acc)
                                          (ht-create)
                                          (s-split "" (s-replace "J" "" string) t)))
                     (unique (length (ht-keys hand)))
                     (bid (->> pieces (cadr) (string-to-number)))
                     (table (ht-create)))

                (ht-set table 'string string)
                (ht-set table 'hand hand)
                (ht-set table 'bid bid)
                (ht-set table 'unique unique)
                (ht-set table 'type (let ((counts (sort (ht-values hand) '<)))
                                      (when (and counts (> jokers 0))
                                        (setq counts
                                              (--update-at (- (length counts) 1) (+ it jokers) counts))
                                        )

                                      (cond
                                       ((or (eq unique 1)
                                            (eq jokers 5)) 7)

                                       ((and (eq unique 2)
                                             (equal '(1 4) counts)) 6)

                                       ((and (eq unique 2)
                                             (equal '(2 3) counts)) 5)

                                       ((and (eq unique 3)
                                             (equal '(1 1 3) counts)) 4)

                                       ((and (eq unique 3)
                                             (equal '(1 2 2) counts)) 3)

                                       ((and (eq unique 4)
                                             (equal '(1 1 1 2) counts)) 2)

                                       ((eq unique 5) 1)
                                       )))

                table
                ))
       (--group-by (ht-get it 'type))
       (--sort (< (car it) (car other)))
       (--map (-sort #'aoc-d7-compare (cdr it)))
       (-flatten)
       (--map-indexed (* (ht-get it 'bid) (+ 1 it-index)))
       (-sum)
       ))
