(declare-const x (RegEx String))
(declare-const y (RegEx String))
(simplify (re.reverse (re.++ x (re.++ y x))))
(simplify (re.reverse (re.++ (str.to_re "a") x (str.to_re "b"))))
