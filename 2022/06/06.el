(--> "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
     (setq aoc-d6-string it)
     (length it)
     (number-sequence 1 (- it 14))
     (--map (substring-no-properties aoc-d6-string (- it 1)  (+ it 13)) it)
     (--find-index (= 14 (length (-distinct (aoc-s-split "" it)))) it)
     (+ 14 it))




                                        ;mjqjpqmgbljsphdztnvjfqwrcgsmlb: first marker after character 19
                                        ;bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 23
                                        ;nppdvjthqldpwncqszvftbrmjlhg: first marker after character 23
                                        ;nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 29
                                        ;zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 26


;;; one
(--> (f-read "data")
     (setq aoc-d6-string it)
     (length it)
     (number-sequence 1 (- it 4))
     (--map (substring-no-properties aoc-d6-string (- it 1)  (+ it 3)) it)
     (--find-index (= 4 (length (-distinct (aoc-s-split "" it)))) it)
     (+ 4 it))

(--> (f-read "data")
     (setq aoc-d6-string it)
     (length it)
     (number-sequence 1 (- it 14))
     (--map (substring-no-properties aoc-d6-string (- it 1)  (+ it 13)) it)
     (--find-index (= 14 (length (-distinct (aoc-s-split "" it)))) it)
     (+ 14 it))
