(declare-const bv (_ BitVec 8))
(declare-const bw (_ BitVec 32))
(assert (distinct bv bw))
(check-sat)
