(set-logic ALL)
(declare-const a (FiniteSet Int))
(assert (= (set.size (set.union a (set.singleton 1))) 1))
(check-sat)
