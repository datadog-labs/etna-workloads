(define-funs-rec ((f ((x Int)) Int) (g ((x Int)) Int)) ((+ 1 (g x)) (+ 1 (f x))))
(declare-const a Int)
(assert (> (f 0) a))
(check-sat)
