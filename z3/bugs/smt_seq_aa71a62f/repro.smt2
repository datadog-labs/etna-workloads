(declare-const s String)
(assert (< (str.len s) 10))
(assert (= (str.at s 50000000) "a"))
(check-sat)
