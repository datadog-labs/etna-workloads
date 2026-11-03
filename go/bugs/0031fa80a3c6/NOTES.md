repro.sh builds a non-main package with a struct whose blank field `_ u` is an array of structs,
initialized by literals whose values have side effects (1/x, *p, s[0]), so the compiler's
`fixedlit` recurses with var_ == blank.

clean: builds fine (exit 0).
buggy: the missing isBlank handling in walk/complit.go makes it fail with
`./p.go:6:21: cannot use _ as value` (exit 1).
