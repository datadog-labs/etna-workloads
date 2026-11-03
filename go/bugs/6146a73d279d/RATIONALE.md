# Rationale

Fix hunk reversed: in `rangeKeyVal`'s `isInteger(typ)` case, the
`allowVersion(go1_22)` check returning `bad("requires go1.22 or later")`
(fix hunk in types2/stmt.go). In go1.27.3 this lives in
`src/cmd/compile/internal/types2/range.go`. Removing it restores the pre-fix
behaviour: range over an integer is accepted under -lang < go1.22.
The `allowVersion` parameter and `go1_22` var remain (still used/harmless).

Failing oracle cases (types2): TestCheck, TestCheck/go1_22_21.go,
TestFixedbugs, TestFixedbugs/issue64704.go, TestIssue68334 — the expected
"cannot range over 10 ...: requires go1.22 or later" error is no longer reported.
