(--> "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"
     (s-split "\n\n" it)
     (--map (-map 'string-to-number (s-split "\n" it)) it)
     (--map (-sum  it) it)
     (-max it))

;;; one
(->> (f-read-text "data")
     (s-split "\n\n")
     (--map (-map 'string-to-number (s-split "\n" it)))
     (--map (-sum  it))
     (-max)
     (number-to-string)
     (kill-new))

;;; two
(->> (f-read-text "data")
     (s-split "\n\n")
     (--map (-map 'string-to-number (s-split "\n" it)))
     (--map (-sum  it))
     (-sort '>)
     (-take 3)
     (-sum)
     (number-to-string)
     (kill-new))
