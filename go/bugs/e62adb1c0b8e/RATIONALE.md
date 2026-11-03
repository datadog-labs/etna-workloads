# Rationale

Fix hunk reversed: `devirtualizeCall` in inl.go (now `src/cmd/compile/internal/devirtualize/devirtualize.go`).
The fix added an `ODOTINTER` case (promoted method from an embedded interface-typed field) that rewrites the call to `OCALLINTER` ("partially devirtualizing"). Before the fix, only `ODOTMETH` was handled and anything else was a warn-and-return ("failed to devirtualize").

Change: removed the `case ir.ODOTINTER:` branch, and restored the pre-fix `default` behaviour (warn under -m and return, instead of `FatalfAt`). The call is left as an unmodified interface call, so `var i I = T{}; i.M()` no longer gets the T literal stack-allocated.

Oracle: `test/escape_iface.go` fails in `issue42279`: `T{} escapes to heap` instead of `does not escape`, and the "partially devirtualizing i.M to T" message is replaced by "failed to devirtualize i.(T).I.M (DOTINTER)".
