# Rationale

The fix's types2 hunks still apply in go1.27.3 (the `isValidName` helper already existed); I removed its three call sites in `src/cmd/compile/internal/types2`. The helper is left in `predicates.go`, now unused.

- `typexpr.go` `ident`: `else if isValidName(e.Value)` -> `else`. This reverses the typexpr hunk. An undeclared name that contains an invalid character gets a spurious "undefined: ..." error.
- `call.go` `selector`, cgo-prefix path: removed the `isValidName(sel)` guard around "undefined: %s". This reverses the first call.go hunk.
- `call.go` `selector`, ordinary package path: `!pkg.fake && isValidName(sel)` -> `!pkg.fake`. This reverses the second call.go hunk. The go1.27.3 code also has a "but have ..." suggestion branch inside this condition, and that branch is now reachable for invalid names too.

The go/types hunks are outside the allowed scope and were not touched.

## Oracle failures
`TestLocal` and `TestLocal/issue68183.go` fail. The parser already reports "invalid character" for `☹x`, `fmt.☹x` and similar, and the type checker now also reports "undefined: ☹x". The test file has no matching ERROR comment for that second error, so the test fails.
