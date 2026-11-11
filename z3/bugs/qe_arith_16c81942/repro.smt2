(declare-const a Real)
(assert (forall ((v Real)) (= (= a v) (= v 0))))
(apply qe)
