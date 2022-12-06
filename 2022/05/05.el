(defun aoc-parse-move-command (move-string)
  (let* ((parts (s-split " " move-string ))
         (how-many (string-to-number (nth 1 parts)))
         (from (string-to-number (nth 3 parts)))
         (to (string-to-number (nth 5 parts))))
    `(,how-many ,from ,to)))

(defun aoc-apply-move-command (crates commands)
  (let ((how-many (car commands))
        (from (nth 1 commands))
        (to (nth 2 commands)))
    (if (= how-many 0)
        crates
      (let* ((from-crates (nth (- from 1) crates))
             (to-crates (nth (- to 1) crates))
             (new-from-crates (cdr from-crates))
             (new-to-crates (append (list (car from-crates)) to-crates)))
        (setf (nth (- from 1) crates) new-from-crates)
        (setf (nth (- to 1) crates) new-to-crates)
        (aoc-apply-move-command crates `(,(- how-many 1) ,from ,to))))))

(progn
  (defun aoc-apply-move-command-part-2 (crates commands)
    (let ((how-many (car commands))
          (from (- (nth 1 commands) 1))
          (to (- (nth 2 commands) 1)))
      (let* ((from-crates (nth from crates))
             (to-crates (nth to crates))
             (new-from-crates (-drop how-many from-crates))
             (new-to-crates (append (-take how-many from-crates) to-crates)))
        (setf (nth from crates) new-from-crates)
        (setf (nth to crates) new-to-crates)
        crates
        )))

  ;; (aoc-apply-move-command-part-2 '((N Z) (D C M) (P)) '(2 2 1))
  )


;;; example
(let ((crates '((N Z) (D C M) (P))))
  (->> "move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2"
       (s-split "\n")
       (-map 'aoc-parse-move-command)
       (--reduce-from (aoc-apply-move-command-part-2 acc it) crates)
       ))

;;; one
(let ((crates '(
                (g b d c p r)
                (g v h)
                (m p j d q s n)
                (m n c d g l s p)
                (s l f p c n b j)
                (s t g v z d b q)
                (q t f h m z b)
                (f b d m c)
                (g q c f)
                )))
  (->> (aoc-data-as-lines)
       (-map 'aoc-parse-move-command)
       (--reduce-from (aoc-apply-move-command acc it) crates)
       (-map 'car)
       (-map 'symbol-name)
       (s-join "")
       (kill-new)))


(let ((crates '(
                (g b d c p r)
                (g v h)
                (m p j d q s n)
                (m n c d g l s p)
                (s l f p c n b j)
                (s t g v z d b q)
                (q t f h m z b)
                (f b d m c)
                (g q c f)
                )))
  (->> (aoc-data-as-lines)
       (-map 'aoc-parse-move-command)
       (--reduce-from (aoc-apply-move-command-part-2 acc it) crates)
       (-map 'car)
       (-map 'symbol-name)
       (s-join "")
       (kill-new)))
