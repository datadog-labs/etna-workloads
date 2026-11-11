(declare-const s String)
(assert (str.in_re s ((_ re.loop 3 1) (str.to_re "a"))))
(check-sat)
