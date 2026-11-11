(declare-const a Bool)(declare-const b Bool)(declare-const c Bool)(declare-const d Bool)(declare-const e Bool)
(assert ((_ pbeq 2 1 1 1 1 1) a b c d e))
(assert a)(assert b)(assert c)
(check-sat-using (then pb2bv sat))
