# Adapted injection for Provide placeholder generic arguments for traits in "no method found for type parameter" suggestions

Fix: https://github.com/rust-lang/rust/commit/02add7d0fbc65296af285fe5c62b36b42a9f476f

compiler/rustc_hir_typeck/src/method/suggest.rs, suggest_traits_to_import (Node::GenericParam / "restrict type parameter" branch; code moved from the old location in the diff).
Replaced the block computing `candidate_strs` with placeholder args (`format!("{cand_path}</* {cand_args} */>")`, `applicability = HasPlaceholders`) by plain `tcx.def_path_str(cand.def_id)` and fixed `Applicability::MaybeIncorrect`. Re-expresses hunk `@@ -3874,22 +3874,52 @@` (and the following two hunks that use `candidate_strs`/`applicability`). The lib.rs `iter_intersperse` feature hunk is not needed (the feature gate is simply left unused).
