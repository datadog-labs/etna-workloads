(declare-datatypes () ((L (nil) (cons (hd Int) (tl L)))))
(declare-const x L)
(declare-const y L)
(mbp-qel ((is-nil x) (= (tl x) y)) (x))
