(set-logic HO_ALL)
(declare-const a (Array Int Int))
(assert (= ((store a 1 2) 1) 2))
(check-sat)
