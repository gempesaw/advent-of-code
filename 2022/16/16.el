;; (let ((native-comp-speed 3))
;;   ;; (native-compile #'fibonacci)
;;   )

(defun aoc-valve-get (name)
  (--find (s-equals-p (car it) name) valves))

(defun aoc-valve-new-score (score opened-valves)
  (->> opened-valves
     (--map (cadr (aoc-valve-get it)))
     (-sum)
     (+ score)))

(defun aoc-valve-walk (valves)
  (let* ((score 0)
         (visited '())
         (queue '("AA"))
         (minute 1)
         (highest 0)
         (timeout 30)
         (opened-valves '()))
    (loop-while queue
      (let* ((current-valve-name (car queue))
            (current-valve (aoc-valve-get current-valve-name)))
        (setq queue (cdr queue))
        (setq minute (+ 1 minute))

        (when (and (eq minute timeout)
                   (> highest score))
          (setq highest score)
          (loop-break))

        (when (eq (length opened-valves) (length target-valves))
          (setq score (+ score (aoc-valve-new-score score opened-valves)))
          (loop-continue))

        (when (and (-contains-p target-valves current-valve-name)
                   (not (-contains-p opened-valves current-valve-name)))
          (append opened-valves (-list current-valve-name))
          (loop-continue))))))

;; def dfs(visited, graph, node):
;;     if node not in visited:
;;         print (node)
;;         visited.add(node)
;;         for neighbour in graph[node]:
;;             dfs(visited, graph, neighbour)

(progn
  (setq opened-valves '())
  (defun aoc-valve-walk (valves visited valve-name score turn)
    (cond ((eq (length visited) 30) score)
          ((eq (length opened-valves) (length target-valves))
           (aoc-valve-walk valves visited valve-name (+ score (aoc-valve-new-score score opened-valves)) turn ))

          ((and (-contains-p target-valves valve-name)
                (not (-contains-p opened-valves valve-name)))
           (append opened-valves (-list valve-name))
           (aoc-valve-walk valves visited valve-name (+ score (aoc-valve-new-score score opened-valves)) turn))

          ((not (-contains-p visited valve-name))
           (push valve-name visited)
           (message (format "%s" visited))
           (sit-for 0)
           (--each (-last-item (aoc-valve-get valve-name)) (aoc-valve-walk valves visited it score) turn))
          ))

  (aoc-valve-walk valves '() "AA" 0))


(setq valves (->> "Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II"
                  (aoc-s-split "\n")
                  (--map (->> it
                              (s-match "Valve \\(..\\).*rate=\\(.+\\);.*to valves? \\(.*\\)")
                              (cdr)))
                  (--map `(,(car it) ,(string-to-number (cadr it)) ,(aoc-s-split ", " (nth 2 it))))))

(setq target-valves (->> valves
                         (--filter (> (cadr it) 0))
                         (--map (car it))))
