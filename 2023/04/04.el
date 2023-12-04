;;; part 1
(->> (aoc-data-as-lines)
     (--map (->> it
                 (s-split "[:\|]")
                 (cdr)
                 (--map (->> (s-split " " it t)
                             (-map #'string-to-number)))
                 (funcall (lambda (line) (-intersection (nth 0 line) (nth 1 line))))
                 (--reduce-from (* 2 acc) 1)
                 ))
     (--map (/ it 2))
     (-sum)
     (number-to-string)
     (kill-new)
     )


(let ((cards (->> (aoc-data-as-lines)
                  (--map (->> (s-split "[:\|]" it)
                              (funcall (lambda (it)
                                         ;; card number, intersections,
                                         `(
                                           ,(string-to-number (nth 1 (s-split " +" (nth 0 it)))) ;card number
                                           ,(length (-intersection (->> (s-split " +" (nth 1 it) t)
                                                                        (-map #'string-to-number))
                                                                   (->> (s-split " +" (nth 2 it) t)
                                                                        (-map #'string-to-number))))
                                           )))))

                  )))
  (->> (--reduce-from
        (let* ((current-card-index (nth 0 it))
               (table-index (- current-card-index 1))
               (matches (nth 1 it))
               (times (ht-get acc table-index)))
          ;; (message (format "%s" (ht-values acc)))
          (when (> matches 0)
            (-dotimes matches
              (lambda (n)
                (let* ((new-card-copy-index (+ n current-card-index 1))
                       (table-copy-index (+ n table-index 1))
                       (card-current-copies (ht-get acc table-copy-index))
                       (new-copies-count (+ times card-current-copies)))
                  ;; (message (format "card %s has %s matches; currently adding %s copies to card %s (index %s); previously %s, next %s"
                  ;;                  current-card-index
                  ;;                  matches
                  ;;                  times
                  ;;                  new-card-copy-index
                  ;;                  table-copy-index
                  ;;                  card-current-copies
                  ;;                  new-copies-count))
                  (ht-set! acc table-copy-index new-copies-count))
                )
              )
            )
          ;; (message (format "%s" (ht-values acc)))
          acc
          )

        (let ((table (ht-create)))
          (-dotimes (length cards)
            (lambda (n)
              (ht-set! table n 1)))
          table)
        cards
        )
       (ht-values)
       (-sum)
       (message)
       )


  ;; (-sum)
  ;; (funcall (lambda (it)
  ;;            (message (format "%s" it))
  ;;            (->> it
  ;;                 (number-to-string)
  ;;                 (kill-new))
  ;;            ))
  )
