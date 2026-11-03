# Rationale

File: src/cmd/compile/internal/escape/escape.go, `rewriteWithLiterals`.

The fix added `assignTemp` calls so that side effects of the original operand are evaluated before it is replaced by a literal. In go1.27.3 the helper still exists, so I removed two of its call sites:

1. OCONVIFACE case: dropped `assignTemp(conv.Pos(), conv.X, conv.PtrInit())`. This reverses the fix hunk that added the call before `conv.X = ir.NewBasicLit(...)`. The call to `crashOnErr(err)` is replaced by its static value, and the call, along with its panic, disappears.
2. OMAKESLICE, OLITERAL sub-case: dropped `assignTemp(n.Pos(), *r, n.PtrInit())` before `*r = ir.NewBasicLit(...)`. This reverses the fix hunk that added the call in the make path.

The OLEN sub-case, added after the fix, and the `assignTemp` helper are untouched. The helper stays in use, so the build still compiles.

## Oracle results
- issue74379.go fails. It prints `false` and then "failed to have expected panic", because the call to `crashOnErr` is dropped from the `fmt.Println` argument.
- issue74379b.go (make) and issue74379c.go still pass. The make case did not fail in the check run. I did not investigate why, but another path (such as the hash or the ordering of the rewrite) may mask it.
