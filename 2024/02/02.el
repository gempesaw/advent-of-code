(->> "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"
     (aoc-split-newlines)
     (--map (-map 'string-to-number (s-split " " it)))
     (--map (-zip-pair it (cdr it)))
     (--map (--reduce-from (let* ((l (car it))
                                  (r (cdr it))
                                  (diff (- (car it) (cdr it)))
                                  (safe (car acc))
                                  (this-sign (if (> diff 0) "+" "-"))
                                  (acc-sign (if (cadr acc) (cadr acc) this-sign)))
                             (message (format "%s %s %s %s %s %s" l r diff safe this-sign acc-sign))
                             (list
                              (and safe
                                   (s-equals-p this-sign acc-sign)
                                   (< (abs diff) 4)
                                   (not (eq 0 diff)))
                              this-sign))
                           '(t nil)
                           it))
     (--filter (car it))
     (length)
     )


(defun aoc-read-data (&optional sample)
  (let ((text (if sample sample (f-read-text "data"))))
    (s-split "\n" text t)))

;;; one
(->> (aoc-read-data)
     (--map (-map 'string-to-number (s-split " " it)))
     (--map (-zip-pair it (cdr it)))
     (--map (--reduce-from (let* ((l (car it))
                                  (r (cdr it))
                                  (diff (- (car it) (cdr it)))
                                  (safe (car acc))
                                  (this-sign (if (> diff 0) "+" "-"))
                                  (acc-sign (if (cadr acc) (cadr acc) this-sign)))
                             (list
                              (and safe
                                   (s-equals-p this-sign acc-sign)
                                   (< (abs diff) 4)
                                   (not (eq 0 diff)))
                              this-sign))
                           '(t nil)
                           it))
     (--filter (car it))
     (length))

;;; two
(->>
 ;; "7 6 4 2 1
 ;; 1 2 7 8 9
 ;; 9 7 6 2 1
 ;; 1 3 2 4 5
 ;; 8 6 4 4 1
 ;; 1 3 6 7 9"
 (aoc-read-data)
 (--map (-map 'string-to-number (s-split " " it)))
 (--map (->> it
             (-repeat (length it))
             (--map-indexed (-remove-at it-index it))
             ;; (--map (progn (message (format "%s" it))
             ;;                    it))
             (--map (-zip-pair it (cdr it)))
             (--map (--reduce-from (let* ((l (car it))
                                          (r (cdr it))
                                          (diff (- (car it) (cdr it)))
                                          (safe (car acc))
                                          (this-sign (if (> diff 0) "+" "-"))
                                          (acc-sign (if (cadr acc) (cadr acc) this-sign)))
                                     (list
                                      (and safe
                                           (s-equals-p this-sign acc-sign)
                                           (< (abs diff) 4)
                                           (not (eq 0 diff)))
                                      this-sign))
                                   '(t nil)
                                   it))
             (--map (car it))
             (--reduce-from (or acc it) nil)
             )
        )
 (-non-nil)
 (length)
 (aoc-kill-new)
 )


(defun aoc-kill-new (number-or-string)
  (let ((num (if (numberp number-or-string)
                 (number-to-string number-or-string)
               number-or-string)))
    (kill-new num)
    num))


(let ((levels '((7 6 4 2 1))))
  (->> levels
       ))
