;;; one
(->> (aoc-data-as-lines)
     (--map (->> it
                 (aoc-s-split "")
                 (--keep (s-match "[0-9]" it))
                 ))
     (--map (->> (cons (car (-first-item it)) (-last-item it))
                 (s-join "")
                 (string-to-number)))
     (-sum)
     (number-to-string)
     ;; (kill-new)
     )


;;; two
(let ((lookup '(
                ;; dumb way to let `oneeight` become "18" instead of "1ight" or "on8"
                ("one" . "one1one")
                ("two" . "two2two")
                ("three" . "three3three")
                ("four" . "four4four")
                ("five" . "five5five")
                ("six" . "six6six")
                ("seven" . "seven7seven")
                ("eight" . "eight8eight")
                ("nine" . "nine9nine")
                )))

  (defun aoc-d1-replace (haystack)
    (-reduce-from (lambda (acc needle) (s-replace (car needle) (cdr needle) acc))
                  haystack
                  lookup))

  (->> (aoc-data-as-lines)
       (--map (aoc-d1-replace it))
       (--map (->> it
                   (aoc-s-split "")
                   (--keep (s-match "[0-9]" it))
                   ))
       (--map (->> (cons (car (-first-item it)) (-last-item it))
                   (s-join "")
                   (string-to-number)))
       (-sum)
       (number-to-string)
       (kill-new)))
