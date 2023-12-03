(let* ((grid (->> (aoc-data-as-lines)
                  (--map (->> (s-split "" it t)
                              (--map (if (s-match "[0-9]" it)
                                         (string-to-number it)
                                       it))))))
       (gridlen (length grid)))

  (defun aoc-d3-is-symbol (point)
    (let ((value (aoc-d3-xy point)))
      (setq result (if (integerp value)
                       nil
                     (not (or (s-match "[0-9]" value)
                              (s-equals? "." value)))))
      ;; (message (format "%s" `(,point ,result ,value)))
      result))


  (defun aoc-d3-xy (point)
    (let ((value (ignore-errors (nth (nth 0 point) (nth (nth 1 point) grid)))))
      (if value
          value
        ".")))

  (defun aoc-d3-points-to-check (point)
    (->> '((-1 -1)
           (-1 0)
           (-1 1)
           (0 -1)
           (0 1)
           (1 -1)
           (1 0)
           (1 1))
         (--map `(,(+ (nth 0 it) (nth 0 point))
                  ,(+ (nth 1 it) (nth 1 point))))
         ;; (--filter (and (not (or (> 0 (nth 0 it))
         ;;                         (> 0 (nth 1 it))))
         ;;                (not (or (> gridlen (nth 0 it))
         ;;                         (> gridlen (nth 1 it))))) )
         ))

  (defun aoc-d3-xy-slurp-integer (point)
    (let ((maybe-integer (aoc-d3-xy point)))
      maybe-integer))

  (defun aoc-d3-collect-part-numbers (points-to-check)
    (->> points-to-check
         (--map (aoc-d3-xy-slurp-integer it))))


  (->> grid
       (-map-indexed
        (lambda (y row)
          (-reduce-from (lambda (acc it)
                          ;; (message (format "%s %s"  acc it))
                          (let ((next-x (+ 1 (nth 0 acc)))
                                (is-valid (nth 1 acc))
                                (new-is-valid)
                                (current-part-number (nth 2 acc))
                                (valid-part-numbers (nth 3 acc)))

                            (if (integerp it)
                                (if (not is-valid)
                                    (progn
                                      (setq new-is-valid (->> (aoc-d3-points-to-check `(,(nth 0 acc) ,y))
                                                              (--map (aoc-d3-is-symbol it))
                                                              (--reduce (or acc it))))
                                      ;; (message (format "%s" `(,acc ,it ,is-valid ,new-is-valid)))
                                      `(
                                        ,next-x

                                        ;; check all the nearby points for a symbol
                                        ,new-is-valid

                                        ,(-concat current-part-number `(,it))
                                        ,valid-part-numbers
                                        ))

                                  ;; it's already valid, just keep track of the part number
                                  `(
                                    ,next-x
                                    ,is-valid
                                    ,(-concat current-part-number `(,it))
                                    ,valid-part-numbers
                                    )
                                  )

                              (if (not (null current-part-number))
                                  (if is-valid
                                      `(,next-x () () ,(-snoc valid-part-numbers current-part-number))
                                    `(,next-x () () ,valid-part-numbers)
                                    )
                                `(,next-x () () ,valid-part-numbers)
                                )
                              )
                            ))

                        ;; x, valid?, current-part-number, valid-part-numbers
                        '(0 () () ())
                        row)
          ))
       (--map (-last-item it))
       (-non-nil)
       (-flatten-n 1)
       (--map (->> it
                   (-map #'number-to-string)
                   (s-join "")
                   (string-to-number)
                   ))
       ;; (--map (insert (format "%s\n" it)))
       (-sum)
       (number-to-string)
       (kill-new)
       )

  )
