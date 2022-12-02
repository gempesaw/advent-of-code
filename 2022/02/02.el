(progn
  (defun aoc-choice-score (round)
    (let ((choice-score-alist '(("X" 1) ("Y" 2) ("Z" 3))))
      (--> round
           (s-split " " it)
           (cadr it)
           (cadr (assoc it choice-score-alist)))))

  (defun aoc-outcome-score (round)
    (let* ((opponent (s-replace "C" "Z" (s-replace "B" "Y" (s-replace "A" "X" (car (s-split " " round))))))
           (me (cadr (s-split " " round)))
           (winner (s-replace "[" "X" (char-to-string (1+ (string-to-char opponent))))))
      (if (s-equals-p opponent me)
          3
        (if (s-equals-p me winner)
            6
          0))))


  (defun aoc-choose-play-from-round (round)
    (let* ((opponent (s-replace "C" "Z" (s-replace "B" "Y" (s-replace "A" "X" (car (s-split " " round))))))
           (outcome (cadr (s-split " " round)))
           (winner (s-replace "[" "X" (char-to-string (1+ (string-to-char opponent)))))
           (loser (s-replace "W" "Z" (char-to-string (1- (string-to-char opponent))))))
      (if (s-equals-p outcome "X")
          (format "%s %s" opponent loser)
        (if (s-equals-p outcome "Y")
            (format "%s %s" opponent opponent)
          (format "%s %s" opponent winner))))))

(->>  "A Y
B X
C Z"
      (s-split "\n")
      (-map 'aoc-choose-play-from-round)
      (--map (+ (aoc-choice-score it) (aoc-outcome-score it)))
      (-sum)
      (number-to-string)
      (kill-new))

;;; one
(->> (f-read-text "data")
     (s-split "\n")
     (--filter (not (s-equals-p it "")))
     (--map (+ (aoc-choice-score it) (aoc-outcome-score it)))
     (-sum)
     (number-to-string)
     (kill-new))

;;; two
(->> (f-read-text "data")
     (s-split "\n")
     (--filter (not (s-equals-p it "")))
     (-map 'aoc-choose-play-from-round)
     (--map (+ (aoc-choice-score it) (aoc-outcome-score it)))
     (-sum)
     (number-to-string)
     (kill-new))
