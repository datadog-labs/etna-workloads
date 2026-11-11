(set-logic QF_S)
(assert (str.< "ab" "abc"))
(check-sat)
