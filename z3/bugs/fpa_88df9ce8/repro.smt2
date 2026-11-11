(declare-const x Int)
(set-option :global-declarations false)
(assert (> x 0))
(check-sat)
