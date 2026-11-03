# Rationale

Fix (go.dev/issue/69477): replaced the position-based `Checker.allowVersion(at poser, v)`
(which looked up `check.versions[pos.FileBase()]`) with `allowVersion(want)` using the
checker's `check.version` state. I restored the position-based lookup in types2 only.

Hunks reversed (all in src/cmd/compile/internal/types2):
- version.go: `allowVersion(at, v)` again derives the file version from `at.Pos().FileBase()`
  (falling back to `Config.GoVersion` for unknown pos); `verifyVersionf` passes `at`.
- call.go, conversions.go, infer.go, literals.go, typeset.go, range.go: call sites pass
  the positions the fix removed (instErrPos, elist[0], call.Pos(), x, pos, lit, atPos(pos), x.expr).
- instantiate.go: passes `nopos` (the old code had a pos here; `implements` no longer
  takes one in go1.27.3, so it uses Config.GoVersion). Not exercised by the oracle.
`check.version` plumbing (declInfo.version, action.version) is left in place but unused for this.

Oracle failure: TestVersionWithoutPos fails. A decl spliced from another file has a
foreign position, so the range-over-func in it is checked against that file's version
(none -> allowed) rather than go1.22, and the expected "requires go1.23" error is missing.
