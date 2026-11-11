(declare-fun and (Bool Bool) Bool)
(declare-const a Bool)
(assert (and a (not a)))
(check-sat)
