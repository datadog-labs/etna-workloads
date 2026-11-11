(declare-const a String)
(simplify (str.substr a (* (str.len a) (str.len a)) (str.len a)))
(simplify (str.substr a (* 3 (str.len a) (str.len a)) 1))
