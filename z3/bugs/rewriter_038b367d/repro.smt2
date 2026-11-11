(declare-const i Int)
(declare-const s Int)
(simplify (mod (+ i s) s))
(simplify (mod (mod i s) s))
