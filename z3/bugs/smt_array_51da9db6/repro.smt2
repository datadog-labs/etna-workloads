(declare-const a Int)
(assert (> (choice ((x Int)) (> x 3)) 0))
(check-sat)
