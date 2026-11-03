# Rationale

Fix cad4dca518a3 (#72090) added, in `canInlineCallExpr` (src/cmd/compile/internal/inline/inl.go),
a check using the call site's inlining-position stack (`parsePos` + loop): if the innermost
position's line/col/file already appears in the outer inline stack, do not inline.

Change: removed that block from `canInlineCallExpr` (the `callees, calleeInner := parsePos(...)`
and the following loop). This reverses the fix's second hunk exactly. `parsePos` (first hunk's
helper) is left defined but unused; the import of cmd/internal/src is still used by it.
The older checks (`repeated recursive cycle` via InlTree) remain, as in the pre-fix tree.

Oracle: test/fixedbugs/issue72090.go (mutually recursive iterator closures) should no longer be
rejected by the position check and inlining may recurse/blow up or fail to compile.
