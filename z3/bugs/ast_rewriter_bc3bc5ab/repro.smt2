(declare-const x (_ FloatingPoint 8 24))
(declare-const y (_ FloatingPoint 8 24))
(simplify (= (fp.add RNE y x) (fp.add RNE x y)))
