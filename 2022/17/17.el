(package-initialize)
(add-to-list 'load-path "~/.emacs.d/elpa")
(load "~/opt/advent-of-code/2022/infra.el")
(require 'ht)
(require 'dash)
(require 's)
(require 'f)
(require 'loop)

(defun aoc-spawn-piece (piece highest-rock)
  (let ((x-shift 2)
        (y-shift highest-rock))
    (--map `(,(+ x-shift (car it)) ,(+ y-shift (cadr it) 4)) piece)))

(defun aoc-jet-push (piece jet boundary)
  (let* ((new-piece (--map `(,(+ jet (car it)) ,(cadr it)) piece))
         (xs (--map (car it) new-piece)))
    (if (or
         ;;  hits the walls
         (< (-min xs) 0) (> (-max xs) 6)

         ;; hits the boundaries
         (--some (-contains-p boundary it) new-piece))
        piece
      new-piece)))

(defun aoc-fall-down (piece boundary)
  (let* ((new-piece (--map `(,(car it) ,(- (cadr it) 1)) piece))
         (new-boundary))
    (if (--none-p (-contains-p boundary it) new-piece)
        `(,new-piece ,boundary ,nil)
      `(,piece ,(aoc-add-to-boundary piece boundary) ,t))))

(defun aoc-add-to-boundary (piece boundary)
  ;; (--each piece (let* ((x (car it))
  ;;                      (y (cadr it))
  ;;                      (boundary-piece (nth x boundary))
  ;;                      (boundary-x (car boundary-piece))
  ;;                      (boundary-y (cadr boundary-piece)))
  ;;                 (when (> y boundary-y)
  ;;                   (setf (nth x boundary) `(,x ,y)))))
  ;; boundary
  (let* ((max-height (-max (--map (cadr it) boundary)))
         (filter-height (- max-height 100))
         (new (append boundary piece)))
    (--filter (> (cadr it) filter-height) new)))

(defun aoc-nth-cycle (index list)
  (nth (mod index (length list)) list))

(defun aoc-max-boundary (boundary)
  (-map (lambda (x)
          `(,x ,(-max (-map 'cadr (--filter (eq (car it) x) boundary)))))
        (number-sequence 0 6)))

;; key = (*self._get_surface_profile(), wind_idx, self.falling_rock.type)
(defun aoc-cache-state (jet-index rock-index piece-count boundary)
  (let* ((max-height (-max (--map (cadr it) boundary)))
         (max-relative-boundary (--map `(,(car it) ,(- max-height (cadr it))) (aoc-max-boundary boundary)))
         (key (format "%s" `(,jet-index ,rock-index ,max-relative-boundary))))
    (setq value (ht-get cache key '()))
    (push `(,piece-count ,max-height) value)
    (ht-set cache key value)))

(setq cache (ht-create))
(setq heights (ht-create))
(let ((jets (->> ;; ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
             (f-read "~/opt/advent-of-code/2022/17/data")
             (s-chomp)
             (aoc-s-split "")
             (--map (if (s-equals-p it ">") 1 -1))
             ))

      (pieces '(
                ((0 0) (1 0) (2 0) (3 0))  ; ####

                ((0 1) (1 1) (2 1) (1 0) (1 2)) ; +

                ((0 0) (1 0) (2 0) (2 1) (2 2)) ; _|

                ((0 0) (0 1) (0 2) (0 3)) ; |

                ((0 0) (1 0) (0 1) (1 1)) ; o
                ))
      (boundary (--map `(,it ,-1) (number-sequence 0 6)))
      (piece)
      (done)
      (piece-index 0)
      (jet-index 0)
      (jets-length)
      (cycle-detected nil))
  (setq jets-length (length jets))

  (loop-for-each piece-count (number-sequence 0 3500)
    (when (eq 0 (mod piece-count 500))
      (message (format "piece-count: %s, cached-states: %s" piece-count (length (ht-keys cache)))))

    (aoc-cache-state jet-index piece-index piece-count boundary)

    (when (not cycle-detected)
      (setq cycle-key-value (ht-find (lambda (key value) (> (length value) 1)) cache))
      (when cycle-key-value
        (setq cycle-detected t
              cycle-start-jet-index jet-index
              cycle-start-piece-index piece-index
              cycle-start-boundary boundary
              cycle-start-piece-count piece-count
              cycle-start-max-height (-max (--map (cadr it) boundary))
              cycle-height-per-delta (apply '- (->> cycle-key-value
                                                    (cadr)
                                                    (-map 'cadr)))
              cycle-pieces-per-cycle (apply '- (->> cycle-key-value
                                                    (cadr)
                                                    (-map 'car))))))

    (setq piece (aoc-spawn-piece (aoc-nth-cycle piece-index pieces) (-max (--map (cadr it) boundary)))
          piece-index (mod (+ 1 piece-index) 5)
          done nil)

    (loop-while (not done)
      (setq piece (aoc-jet-push piece (aoc-nth-cycle jet-index jets) boundary)
            jet-index (mod (+ 1 jet-index) jets-length))

      (setq aoc-fell-down (aoc-fall-down piece boundary))
      (setq piece (nth 0 aoc-fell-down)
            boundary (nth 1 aoc-fell-down)
            done (nth 2 aoc-fell-down)))))

(message (format "cycle-start-jet-index: %s\n cycle-start-piece-index: %s\n cycle-start-piece-count: %s\n" cycle-start-jet-index cycle-start-piece-index cycle-start-piece-count))

(->> cache
     (ht-items)
     (--filter (> (length (cadr it)) 1))
     (--map (format "%s: %s" (car it) (cadr it)))
     (s-join "\n")
     (message))

(let* ((desired-pieces 1000000000000)
       (pieces-before-cycle-starts (- cycle-start-piece-count cycle-pieces-per-cycle))
       (cycles-to-run (--> desired-pieces
                           (- it pieces-before-cycle-starts)
                           (/ it cycle-pieces-per-cycle)))
       (pieces-left-after-cycle (- desired-pieces
                                   (+ pieces-before-cycle-starts (* cycles-to-run cycle-pieces-per-cycle))))
       (max-height-after-cycle (* cycle-height-per-delta cycles-to-run)))
  (kill-new (number-to-string (+ max-height-after-cycle (- 5385 2945)))))
