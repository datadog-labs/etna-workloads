# Adapted injection for Add compiler error when trying to use concat metavar expr in repetitions

Fix: https://github.com/rust-lang/rust/commit/f6e7c81061c24a2210149ff94670d8672bd0224a

# Rationale

## Hunk: compiler/rustc_expand/src/mbe/transcribe.rs, fn `metavar_expr_concat`, `MetaVarExprConcatElem::Var` arm

Re-expresses fix.diff hunk:

    @@ -556,7 +556,12 @@ fn metavar_expr_concat<'tx>(
                             match &named_matches[*curr_idx] {
                                 // FIXME(c410-f3r) Nested repetitions are unimplemented
    -                            MatchedSeq(_) => unimplemented!(),
    +                            MatchedSeq(_) => {
    +                                return Err(dcx.struct_span_err(
    +                                    ident.span,
    +                                    "nested repetitions with `${concat(...)}` metavariable expressions are not yet supported",
    +                                ));
    +                            }

In 1.99.1 this code was rewritten: the variable is looked up via `lookup_cur_matched`
(which descends through all repetition levels), so the fix's exact lines no longer exist.
To bring back the parent-commit behaviour I restored the pre-fix lookup shape that the fix
hunk sits in: look the variable up directly in `interp`; if it is a `MatchedSeq`, index it
only once using the innermost repetition index (`repeats.last()`), and if that element is
itself a `MatchedSeq` (nested repetition) hit `unimplemented!()` — the ICE from issue #140479.
`MatchedSingle` at top level and the `None` (unknown variable) case are unchanged; the
no-repetition-context case keeps the existing "still repeating" error.

Effect: `tests/ui/macros/macro-metavar-expr-concat/in-repetition.rs` (`$arg` at depth 2
used in `${concat(_, $arg)}` inside two repetitions) now panics with "not implemented".
