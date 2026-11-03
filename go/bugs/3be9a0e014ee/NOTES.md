repro.go calls generic `must(s.F())` where `s.F` is an undefined method. After the selector error,
the buggy types2 leaves the operand's type as `S` (not Invalid), so the "not enough arguments"
diagnostic prints `have (S)`; the clean compiler prints `have (unknown type)`. Both exit 1.
