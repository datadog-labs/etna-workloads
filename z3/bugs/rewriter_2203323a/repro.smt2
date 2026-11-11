(set-option :rewriter.expand_store_eq true)
(assert (= (store ((as const (Array Bool Int)) 0) false 1)
           (store ((as const (Array Bool Int)) 1) true 0)))
(check-sat)
