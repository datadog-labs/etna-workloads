(declare-const x (_ FloatingPoint 8 24))
(declare-const r RoundingMode)
(assert (= ((_ fp.to_sbv 1) r x) #b1))
(check-sat)
