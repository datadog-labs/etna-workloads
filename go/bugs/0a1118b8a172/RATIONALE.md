# Rationale

Fix (go/types, types2, #55030) made `NewSignatureType` accept a variadic last
parameter whose core type is a slice or string, instead of only a literal `*Slice`.

In go1.27.3 this logic is the `typeset(last)` loop in
`src/cmd/compile/internal/types2/signature.go`. I replaced it with the pre-fix
check: panic unless `params.At(n-1).typ` is a `*Slice`. The now-unused `fmt` import was removed.
This reverses the `signature.go` hunk (the `coreString`/`isString` check back to the `.(*Slice)` assertion).

Oracle: `TestIssue55030` fails, panicking with "variadic parameter must be of
unnamed slice type" for `func(string...)`. The panic aborts the test binary, so
the other types2 tests are reported failing too.
