(set-logic ALL)
(declare-const m RoundingMode)
(assert (not (= ((_ to_fp 5 11) m (- 0.1)) ((_ to_fp 5 11) m (- 0.1) 0))))
(check-sat)
