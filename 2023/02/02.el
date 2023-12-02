
(let ((red-cubes 12)
      (green-cubes 13)
      (blue-cubes 14))

  (defun aoc-d2-max-cubes (target-color string)
    (->> (s-match-strings-all (format "\\([0-9]+\\) %s" target-color) string)
         (--map (string-to-number (cadr it)))
         (-max)))

  ;; part 1
  (->> (aoc-data-as-lines)
       (--map (let ((id (string-to-number (cadr (s-match "Game \\([0-9]+\\):" it))))
                    (red (aoc-d2-max-cubes "red" it))
                    (green (aoc-d2-max-cubes "green" it))
                    (blue (aoc-d2-max-cubes "blue" it)))
                `(,id ,red ,green ,blue)))
       (--filter (and (<= (cadr it) red-cubes)
                      (<= (caddr it) green-cubes)
                      (<= (cadddr it) blue-cubes)))
       (--map (car it))
       (-sum)
       (number-to-string)
       (kill-new)

       )

  )

;;; part 2
(->> (aoc-data-as-lines)
     (--map (let ((id (string-to-number (cadr (s-match "Game \\([0-9]+\\):" it))))
                  (red (aoc-d2-max-cubes "red" it))
                  (green (aoc-d2-max-cubes "green" it))
                  (blue (aoc-d2-max-cubes "blue" it)))
              ;; The power of a set of cubes is equal to the numbers of red,
              ;; green, and blue cubes multiplied together
              (* red green blue)))
     (-sum)
     (number-to-string)
     (kill-new)


     )
