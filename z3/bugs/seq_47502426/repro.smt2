(assert (= (seq.last_indexof (seq.++ (seq.unit 10) (seq.unit 20)) (seq.unit 20)) 1))
(check-sat)
