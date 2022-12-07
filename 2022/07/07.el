(progn
  (defun aoc-build-files (files lines &optional current-directory)
    (if (not lines)
        (-sort #'string< (reverse files))

      (let ((cwd (if current-directory current-directory ""))
            (command (car lines))
            (tail (cdr lines)))
        (cond ((s-starts-with? "$ cd " command) (let ((directory (cadr (s-split "cd " command))))

                                                  (if (s-equals-p ".." directory)
                                                      (aoc-build-files files tail (s-join "/" (-drop-last 1 (s-split "/" cwd))))
                                                    (aoc-build-files files tail (s-replace "//" "/" (format "%s/%s" cwd directory))))))
              ((s-equals-p "$ ls" command) (aoc-build-files files tail cwd))
              ((s-matches-p "dir " command) (aoc-build-files files tail cwd))
              (t (aoc-build-files (cons (s-replace "//" "/" (format "%s/%s" cwd (car (s-split " " command)))) files)
                                  tail
                                  cwd))))))


  (defun aoc-sum-directory-sizes (directories files)
    (if (not files)
        directories
      (let* ((dirs (if directories directories (make-hash-table)))
             (file (car files))
             (next-files (cdr files))
             (file-parts (s-split "/" file))
             (size (string-to-number (-last-item file-parts)))
             (parent-dirs (s-split "," (--reduce (format "%s,%s" acc (s-replace "," "" (format "%s/%s" acc it))) (-drop-last 1 file-parts)))))
        (-each parent-dirs (lambda (x) (puthash x (+ size (gethash x dirs 0)) dirs)))
        (aoc-sum-directory-sizes dirs next-files))))

  (message "\n\n\n")

  (->> "$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"
       (aoc-s-split "\n")
       (aoc-build-files '())
       (aoc-sum-directory-sizes (make-hash-table :test 'equal))
       (ht-items)
       (--filter (< (cadr it) 100000))
       (--map (+ (cadr it)))
       (-sum)
       (number-to-string)
       (kill-new))
  )



(let ((max-specpdl-size 50000)
      (max-lisp-eval-depth 50000))
  (->> (aoc-data-as-lines)
       (aoc-build-files '())
       (aoc-sum-directory-sizes (make-hash-table :test 'equal))
       (ht-items)
       (--filter (< (cadr it) 100000))
       (--map (+ (cadr it)))
       (-sum)
       (number-to-string)
       (kill-new)))


(let ((max-specpdl-size 50000)
      (max-lisp-eval-depth 50000))
  (->> (aoc-data-as-lines)
       (aoc-build-files '())
       (aoc-sum-directory-sizes (make-hash-table :test 'equal))
       (ht-items)
       (reverse)
       (--filter (> (cadr it) 7442399))
       (--min-by (> (cadr it) (cadr other)))
       (cadr)
       (number-to-string)
       (kill-new)
       ))


;; (kill-new (number-to-string (- (- 70000000 30000000)

;;                                (- 70000000 47442399))))
