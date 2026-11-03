# Rationale

Fix hunk reversed (types2/infer.go, simplify step in `Checker.infer`): the block that,
after `check.subst` simplifies an inferred type t0 to t1, nils out `sig.tparams` when t1 is a
generic `*Signature` that is no longer parameterized by `tparams`. In go1.27.3 this block is
still present verbatim (comment typos aside), so removing it restores the pre-fix behaviour:
a generic function argument (e.g. `g[Q int]`) whose signature is fully instantiated by
simplification keeps its stale type parameters and is still treated as generic.
The trace-only and doc-comment hunks are not behavioural and were left alone. go/types is not
part of src/cmd/compile, so only types2 was changed.

Oracle: `TestFixedbugs/issue59953.go` (and its parent `TestFixedbugs`) in
cmd/compile/internal/types2 fail (2 of 592 cases), as the type checker reports an error for `f(g)`.
