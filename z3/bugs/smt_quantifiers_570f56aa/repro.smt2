(declare-fun p (Int) Bool)
(assert (forall ((x Int)) (or (not (p x)) (exists ((y Int)) (and (p y) (> y x))))))
(check-sat)
