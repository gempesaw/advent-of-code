;;; create a new day's directory
;;; paste the kill ring into data file
(defun dg-aoc-new-day ()
  (interactive)
  (let* ((cwd "/Users/dgempesaw/opt/advent-of-code/2022/")
       (latest (car (reverse (f-directories cwd))))
       (next-number (format "%02d" (+ 1 (string-to-number (car (reverse (s-split "/" latest)))))))
       (next-dir (format "%s%s" cwd next-number))
       (next-data (format "%s/data" next-dir))
       (next-el (format "%s/%s.el" next-dir next-number)))
  (f-mkdir next-dir)
  (f-write-text (car kill-ring) 'utf-8 next-data)
  (find-file next-el)
  (insert "(->> (f-read-text \"data\")

)")
  (previous-line)
  (save-buffer)))
