(let ((sample "3   4
4   3
2   5
1   3
3   9
3   3"))

  (->> sample
       (s-split "\n")
       (--map (-map 'string-to-number (s-split "\s+" it)))
       (--filter (eq 2 (length it)))
       (-unzip)
       (--map (-sort #'< it) )
       (funcall
        (lambda (args)
          (let ((left (car args))
                (frequencies (-frequencies (cadr args))))
            (--map (* it (or (cdr (assoc it frequencies))
                             0)) left)
            )))
       (-sum)
       ))

;;; one
(->> (f-read-text "data")
     (s-split "\n")
     (--map (-map 'string-to-number (s-split "\s+" it)))
     (--filter (eq 2 (length it)))
     (-unzip)
     (--map (-sort #'< it) )
     (apply '-zip)
     (--map (let ((l (car it))
                  (r (cdr it)))
              (abs (- l r))))
     (-sum)
     (number-to-string)
     (kill-new))

;;; two
(->> (f-read-text "data")
     (s-split "\n")
     (--map (-map 'string-to-number (s-split "\s+" it)))
     (--filter (eq 2 (length it)))
     (-unzip)
     (--map (-sort #'< it) )
     (funcall
      (lambda (args)
        (let ((left (car args))
              (frequencies (-frequencies (cadr args))))
          (--map (* it (or (cdr (assoc it frequencies))
                           0)) left)
          )))
     (-sum)
     (number-to-string)
     (kill-new)
     )
