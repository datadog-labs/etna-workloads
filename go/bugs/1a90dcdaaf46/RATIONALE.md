# Rationale

Fix hunk (types2/typeset.go `underIs`): `u := Unalias(t.typ)` for ~T terms instead of `u := t.typ`.
In go1.27.3 `underIs` was refactored into `_TypeSet.all` (src/cmd/compile/internal/types2/typeset.go), which
has the same loop. I reverted it to the pre-fix computation: `u := t.typ` for tilde terms (no Unalias),
so an alias `~A` passes the alias A, not its underlying type, to the callback.
(go/types is outside the allowed scope and untouched.)

Oracle failures: TestFixedbugs/issue68903.go, TestFixedbugs/issue68935.go (and parent TestFixedbugs):
len/cap/composite literal/index on type params constrained by ~alias now see a non-underlying type.
