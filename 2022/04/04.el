
(->> "2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"
     (aoc-s-split "\n")
     (--map (--map (->> it
                        (s-split "-")
                        (-map 'string-to-number)
                        (apply 'number-sequence))
                   (s-split "," it)))
     (--count (let* ((first (car it))
                     (second (cadr it))
                     (intersection (-intersection first second)))
                (or (-same-items? first intersection)
                    (-same-items? second intersection))))
     )


;;; one
(->> (aoc-data-as-lines)
     (--map (->> it
                 (s-split ",")
                 (--map (->> it
                             (s-split "-")
                             (-map 'string-to-number)
                             (apply 'number-sequence)))))
     (--count (let* ((first (car it))
                     (second (cadr it))
                     (intersection (-intersection first second)))
                (or (-same-items? first intersection)
                    (-same-items? second intersection))))
     )

;;; two
(->> (aoc-data-as-lines)
     (--map (->> it
                 (s-split ",")
                 (--map (->> it
                             (s-split "-")
                             (-map 'string-to-number)
                             (apply 'number-sequence)))))
     (--count (let* ((first (car it))
                     (second (cadr it))
                     (intersection (-intersection first second)))
                intersection))
     )
