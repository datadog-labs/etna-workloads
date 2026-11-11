(declare-const p Bool)
(simplify (forall ((x Bool)) (and x p)))
(simplify (exists ((x Bool)) (or x p)))
(simplify (not (forall ((x Bool)) (or (not x) p))))
