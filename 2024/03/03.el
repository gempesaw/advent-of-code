(->> "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
     (s-match-strings-all "mul(\\([[:digit:]]+,[[:digit:]]+\\))")
     (--map (->> it
                 (cadr)
                 (s-split ",")
                 (-map 'string-to-number)
                 (apply '*)))
     (-sum))


(->> (f-read-text "data")
     (s-match-strings-all "mul(\\([[:digit:]]+,[[:digit:]]+\\))")
     (--map (->> it
                 (cadr)
                 (s-split ",")
                 (-map 'string-to-number)
                 (apply '*)))
     (-sum)
     (aoc-kill-new))


(->> (f-read-text "data")
     (s-match-strings-all "\\(mul(\\([[:digit:]]+,[[:digit:]]+\\))\\|do()\\|don't()\\)")
     (--reduce-from (let ((enabled (car acc))
                          (instructions (nth 1 acc))
                          (digits (-last-item it)))
                      (if (and enabled
                               (not (s-equals-p (car it) "don't()")))
                          (list enabled (s-concat instructions "|" digits))
                        (if (s-equals-p (car it) "do()")
                            (list t instructions)
                          (list nil instructions))))
                    (list t ""))
     (cadr)
     (s-split "|")
     (--map (->> (s-split "," it)
                 (-map 'string-to-number)
                 (apply '*)))
     (-sum)
     (aoc-kill-new)
     )
