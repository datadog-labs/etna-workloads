(assert (= (store (lambda ((x Int)) x) 7 0)
           (store ((as const (Array Int Int)) 3) 7 0)))
(check-sat)
