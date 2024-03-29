;;; create a new day's directory
;;; paste the kill ring into data file
(defun dg-aoc-new-day ()
  (interactive)
  (let* ((cwd "/Users/dgempesaw/opt/advent-of-code/2023/")
         (latest (car (reverse (f-directories cwd))))
         (next-number (format "%02d" (+ 1 (string-to-number (car (reverse (s-split "/" latest)))))))
         (next-dir (format "%s%s" cwd next-number))
         (next-data (format "%s/data" next-dir))
         (next-el (format "%s/%s.el" next-dir next-number)))
    (f-mkdir next-dir)
    (f-write-text (car kill-ring) 'utf-8 next-data)
    (find-file next-el)
    (insert "(->> (aoc-data-as-lines)

)")
    (beginning-of-buffer)
    (end-of-line)
    (left-char)
    (save-buffer)))

(defun aoc-s-split (separator string)
  (s-split separator string t))

(defun aoc-data-as-lines (&optional filename)
  (let ((file (if filename filename "data")) )
    (->> file
         (f-read-text)
         (s-chomp)
         (aoc-s-split "\n"))))

(require 'loop)


;; (key-chord-define-global "jl" (lambda ()
;;                                 (interactive)
;;                                 (eval-buffer)
;;                                 (save-excursion
;;                                   (goto-char (point-max))
;;                                   (eval-defun nil))))
