(declare-const r Real)
(assert (= ((_ to_fp 8 24) r) ((_ to_fp 8 24) r)))
(check-sat)
