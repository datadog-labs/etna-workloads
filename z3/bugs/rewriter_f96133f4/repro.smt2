(set-logic BV)
(declare-fun p ((_ BitVec 2)) Bool)
(assert (forall ((b Bool) (z (_ BitVec 2))) (or b (forall ((x (_ BitVec 2))) (or (= x z) (p x) (not b))))))
(apply (using-params bit-blast :blast_quant true))
