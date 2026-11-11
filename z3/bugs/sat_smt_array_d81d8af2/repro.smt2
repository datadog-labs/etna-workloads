(set-option :sat.euf true)
(declare-datatypes () ((D d)))
(assert (= (default (store ((as const (Array D Int)) 0) d 1)) 1))
(check-sat)
