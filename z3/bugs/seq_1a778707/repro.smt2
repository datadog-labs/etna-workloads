(declare-const x String)
(declare-const y String)
(assert (= (str.++ x y) (str.++ y x)))
(check-sat)
