# Rationale

go1.27.3 no longer has `dvarint`; `emitOpenDeferInfo` calls `objw.Uvarint` (binary.PutUvarint). The fix replaced the hand-rolled `dvarint` (with its `v > 1e9` panic) by `binary.PutUvarint`.

Change (src/cmd/compile/internal/ssagen/ssa.go): reintroduced the pre-fix `dvarint` verbatim (including the `v < 0 || v > 1e9` panic and the 5-byte manual encoding) and made `emitOpenDeferInfo` call it instead of `objw.Uvarint`. This reverses the fix's single implementation hunk; objw.Uvarint stays untouched.

Oracle: test/fixedbugs/issue52697.go fails. A function with a huge frame and an open-coded defer now panics in `dvarint` ("bad offset for funcdata") with an ICE instead of reporting "stack frame too large" at lines 11 and 20.
