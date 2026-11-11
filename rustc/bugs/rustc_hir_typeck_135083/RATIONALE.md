# Adapted injection for Do not ICE when encountering predicates from other items in method error reporting

Fix: https://github.com/rust-lang/rust/commit/e4193e2de8b1643361656d2cd10bc7402137f8e9

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn report_no_match_method_error (the loop over unsatisfied_predicates matching `self.tcx.hir_get_if_local(item_def_id)` nodes).

Re-expresses fix hunk `@@ -1181,8 +1181,12 @@`: the fix replaced
`Some(node) => unreachable!("encountered `{node:?}` due to `{cause:#?}`"), None => ()`
with a catch-all `_ => {}`. I restored the old arms, so predicates originating from other items (e.g. an ADT, via WF clauses) hit `unreachable!` and ICE.
The first fix hunk (`};` -> `}`) is cosmetic; not re-expressed.
