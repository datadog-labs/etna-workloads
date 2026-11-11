(declare-datatype O (par (X) ((none) (some (val X)))))
(assert (= 1 (match (some 3) ((none 0) (z 1)))))
(check-sat)
