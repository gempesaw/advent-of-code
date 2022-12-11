(defun aoc-parse-monkey-operation (operation)
  (lexical-let* ((parts (s-split " " operation))
                 (operator (cadr parts))
                 (operator-fn (cond ((s-equals-p operator "*") '*)
                                    ((s-equals-p operator "+") '+)))
                 (second-operand (caddr parts)))
    (lambda (old) (funcall operator-fn old (if (s-equals-p "old" second-operand)
                                               old
                                             (string-to-number second-operand))))))

(defun aoc-monkey-handle-items (monkeys &optional current-monkey)
  (setq current-monkey (if current-monkey current-monkey 0))
  (let* ((monkey (nth current-monkey monkeys))
         (items (if monkey (ht-get monkey "items") nil))
         (item (if items (car items) nil)))
    (if monkey
        (if item
            (let* ((rest-items (cdr items))
                   (inspected-item (funcall (ht-get monkey "operation") item))
                   (bored-item (/ inspected-item 3))
                   (target-monkey-index (if (funcall (ht-get monkey "test") bored-item)
                                            (ht-get monkey "true-target")
                                          (ht-get monkey "false-target")))
                   (target-monkey (nth target-monkey-index monkeys))
                   (target-monkey-items (ht-get target-monkey "items")))
              (ht-set target-monkey "items" (append target-monkey-items `(,bored-item)))
              (ht-set monkey "items" rest-items)
              (ht-set monkey "inspections" (+ 1 (ht-get monkey "inspections")))

              (aoc-monkey-handle-items monkeys current-monkey))
          (aoc-monkey-handle-items monkeys (+ 1 current-monkey)))
      monkeys)))

(progn
  (defun aoc-monkey-handle-items-maximum-worry (monkeys &optional current-monkey)
    (setq current-monkey (if current-monkey current-monkey 0))
    (let* ((monkey (nth current-monkey monkeys))
           (items (if monkey (ht-get monkey "items") nil))
           (item (if items (car items) nil)))
      (if monkey
          (if item
              (let* ((rest-items (cdr items))
                     (inspected-item (funcall (ht-get monkey "operation") item))
                     (bored-item (if (> inspected-item 9699690)
                                     (mod inspected-item 9699690)
                                   inspected-item))
                     (target-monkey-index (if (funcall (ht-get monkey "test") bored-item)
                                              (ht-get monkey "true-target")
                                            (ht-get monkey "false-target")))
                     (target-monkey (nth target-monkey-index monkeys))
                     (target-monkey-items (ht-get target-monkey "items")))
                (ht-set target-monkey "items" (append target-monkey-items `(,bored-item)))
                (ht-set monkey "items" rest-items)
                (ht-set monkey "inspections" (+ 1 (ht-get monkey "inspections")))
                (aoc-monkey-handle-items-maximum-worry monkeys current-monkey))
            (aoc-monkey-handle-items-maximum-worry monkeys (+ 1 current-monkey)))
        monkeys)))
  )

(->> "Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1"
     (aoc-s-split "\n\n")
     (--map (lexical-let* ((lines (s-split "\n" it))
                           (number (cadr (s-match "Monkey \\(.\\)" (car lines))))
                           (items (-map 'string-to-number (cdr (s-split ":\\|," (cadr lines)))))
                           (operation (aoc-parse-monkey-operation (cadr (s-split " = " (caddr lines)))))
                           (test (lambda (item) (= 0 (mod item (string-to-number (car (reverse (s-split " " (cadddr lines)))))))))
                           (true-target (string-to-number (car (reverse (s-split " " (cadr (reverse lines)))))))
                           (false-target (string-to-number (car (reverse (s-split " " (car (reverse lines))))))))
              (ht ("number" number)
                  ("items" items)
                  ("operation" operation)
                  ("test" test)
                  ("true-target" true-target)
                  ("false-target" false-target)
                  ("inspections" 0))))

     (funcall (lambda (monkeys)
                (--reduce-from (aoc-monkey-handle-items-maximum-worry acc)
                               monkeys
                               (number-sequence 1 10000))))
     (--map (ht-get it "inspections")))

(->> "replace-with-data-no-trailing-newline"
     (aoc-s-split "\n\n")
     (--map (lexical-let* ((lines (s-split "\n" it))
                           (number (cadr (s-match "Monkey \\(.\\)" (car lines))))
                           (items (-map 'string-to-number (cdr (s-split ":\\|," (cadr lines)))))
                           (operation (aoc-parse-monkey-operation (cadr (s-split " = " (caddr lines)))))
                           (test (lambda (item) (= 0 (mod item (string-to-number (car (reverse (s-split " " (cadddr lines)))))))))
                           (true-target (string-to-number (car (reverse (s-split " " (cadr (reverse lines)))))))
                           (false-target (string-to-number (car (reverse (s-split " " (car (reverse lines))))))))
              (ht ("number" number)
                  ("items" items)
                  ("operation" operation)
                  ("test" test)
                  ("true-target" true-target)
                  ("false-target" false-target)
                  ("inspections" 0))))

     (funcall (lambda (monkeys)
                (--reduce-from (aoc-monkey-handle-items acc)
                               monkeys
                               (number-sequence 1 20))))
     (--map (ht-get it "inspections"))
     (-sort '>)
     (-take 2)
     (-reduce '*)
     (number-to-string)
     (kill-new)
     )


(->> "replace-with-data-no-trailing-newline"
 (aoc-s-split "\n\n")
 (--map (lexical-let* ((lines (s-split "\n" it))
                       (number (cadr (s-match "Monkey \\(.\\)" (car lines))))
                       (items (-map 'string-to-number (cdr (s-split ":\\|," (cadr lines)))))
                       (operation (aoc-parse-monkey-operation (cadr (s-split " = " (caddr lines)))))
                       (test (lambda (item) (= 0 (mod item (string-to-number (car (reverse (s-split " " (cadddr lines)))))))))
                       (true-target (string-to-number (car (reverse (s-split " " (cadr (reverse lines)))))))
                       (false-target (string-to-number (car (reverse (s-split " " (car (reverse lines))))))))
          (ht ("number" number)
              ("items" items)
              ("operation" operation)
              ("test" test)
              ("true-target" true-target)
              ("false-target" false-target)
              ("inspections" 0))))

 (funcall (lambda (monkeys)
            (--reduce-from (aoc-monkey-handle-items-maximum-worry acc)
                           monkeys
                           (number-sequence 1 10000))))
 (--map (ht-get it "inspections"))
 (-sort '>)
 (-take 2)
 (-reduce '*)
 (number-to-string)
 (kill-new)
 )
