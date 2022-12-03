(progn
  (defun aoc-to-priority (char)
    (let ((priority (- (string-to-char char) 96)))
      (if (> priority 0)
          priority
        (+ priority 58))))

  (defun aoc-find-badge (elves)
    (let (
          (first (aoc-s-split "" (car elves)))
          (second (aoc-s-split "" (cadr elves)))
          (third (aoc-s-split "" (caddr elves))))
      (car (-intersection (-intersection first second) third))))


  (->> "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"
       (aoc-s-split "\n")
       (-partition 3)
       (-map 'aoc-find-badge)
       (-map 'aoc-to-priority)
       (-sum)))


;;; one
(--> (aoc-data-as-lines)
     (--map (let* ((halves (-split-at (/ (length it) 2) (s-split "" it t)))
                   (first (car halves))
                   (second (cadr halves)))
              (car (-intersection first second)))
            it)
     (-map 'aoc-to-priority it)
     (-sum it))

;;; two
(->> (f-read-text "data")
     (aoc-s-split "\n")
     (-partition 3)
     (-map 'aoc-find-badge)
     (-map 'aoc-to-priority)
     (-sum))

(--> "vJrwpWtwJgWrhcsFMMfFFhFp"
     (cl-destructuring-bind (first second) (-split-at (/ (length it) 2) (s-split "" it t))
       (car (-intersection first second))))
