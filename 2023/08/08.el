(->> (aoc-data-as-lines)
     (--reduce-from (progn
                      (if (s-match "^[LR]+$" it)
                          (ht-set! acc 'instructions (s-split "" it t))
                        (let* ((parts (s-split "[ =(),]" it t))
                               (key (car parts)))
                          (ht-set! acc key (cdr parts))))
                      acc)
                    (ht ('count 0)))
     (funcall (lambda (nodes)

                (let* ((instructions (ht-get nodes 'instructions))
                       (instructions-length (length instructions))
                       (current-node "AAA"))
                  (while (not (s-equals-p current-node "ZZZ"))
                    (setq side (if (s-equals-p "L"
                                               (nth (% (ht-get nodes 'count)
                                                       instructions-length)
                                                    instructions))
                                   0
                                 1))
                    (setq current-node (nth side (ht-get nodes current-node)))
                    (ht-update-with! nodes 'count #'1+))
                  (ht-get nodes 'count)))))


(->> (aoc-data-as-lines)
     (--reduce-from (progn
                      (if (s-match "^[LR]+$" it)
                          (ht-set! acc 'instructions (s-split "" it t))
                        (let* ((parts (s-split "[ =(),]" it t))
                               (key (car parts)))
                          (ht-set! acc key (cdr parts))))
                      acc)
                    (ht ('count 0)))
     (funcall (lambda (nodes)
                (let* ((instructions (ht-get nodes 'instructions))
                       (instructions-length (length instructions))
                       (walking-nodes (->> nodes
                                           (ht-keys)
                                           (--filter (and (stringp it) (s-match "A$" it)))
                                           (--map (ht ('current-node it)
                                                      ('done nil)
                                                      ('cycle 0)))))
                       (side)
                       (count 0))

                  (while (not (--every (not (eq 0 (ht-get it 'cycle))) walking-nodes))
                    (--each
                        walking-nodes
                      (progn
                        (setq side (if (s-equals-p "L" (nth (% count instructions-length)
                                                            instructions))
                                       0
                                     1))
                        (ht-set! it 'current-node (nth side (ht-get nodes (ht-get it 'current-node))))
                        (if (and (s-ends-with? "Z" (ht-get it 'current-node))
                                 (eq 0 (ht-get it 'cycle)))
                            (progn
                              (ht-set! it 'cycle (+ 1 count))
                              (message (format "%s" (+ 1 count)))))))

                    (setq count (1+ count)))

                  (->> walking-nodes
                       (--map (ht-get it 'cycle))
                       (-reduce #'lcm))))))

;;; randomly found an lcm implementation online :shrug:
;;;
;;; https://ftp.math.utah.edu/pub/emacs/primes.el
(defun lcm (m n)
  "Return the Least Common Multiple of integers M and N, or nil if
they are invalid, or the result is not representable (e.g., the
product M*N overflows).

\[cost: O((12(ln 2)/pi^2)ln max(M,N)) == O(0.8427659... max(M,N))]"
  (cond
   ((and (integerp m) (integerp n))     ; check for integer args
    (let ((mn) (the-gcd) (the-lcm))
      (if (or (= m 0) (= n 0))         ; fast special case: lcm(0,anything) == 0
          0
        ;; else compute lcm from (m * n) / gcd(m,n)
        ;;
        ;; Problem: GNU Emacs Lisp integer multiply does not detect or
        ;; trap overflow, which is a real possibility here, and it lacks
        ;; a double-length integer type to represent the product m * n.
        ;; Since the lcm may still be representable, we do the
        ;; intermediate computation in (double-precision)
        ;; floating-point, which is still not quite large enough to
        ;; represent all products of Emacs 28-bit integers stored in
        ;; 32-bit words, then convert back to integer results.  The
        ;; floor function will signal an error if the result is not
        ;; representable.  To try to avoid that, we first check that the
        ;; equality gcd * lcm = m * n is satisfied, and only if it is,
        ;; do we invoke floor.
        ;;
        ;; TO DO: find better algorithm without these undesirable
        ;; properties.
        (setq m (abs m))             ; argument sign does not matter for lcm, so
        (setq n (abs n))             ; force positive for the algorithm below
        (setq the-gcd (gcd m n))
        (setq mn (* (float m) (float n)))
        (setq the-lcm (/ mn the-gcd))
        (if (= (* the-gcd the-lcm) mn)  ; then got correct answer
            (floor the-lcm)
          nil))))                       ; else out-of-range or invalid
   (t nil)))                ; non-integer args: invalid
