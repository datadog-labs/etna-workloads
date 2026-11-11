# Adapted injection for Marks ADT live if it appears in pattern

Fix: https://github.com/rust-lang/rust/commit/52167e04e62a84fe5073c4074733c72f96961ace

All changes are in compiler/rustc_passes/src/dead.rs.

1. `handle_field_pattern_match` – removed `self.check_def_id(adt.did());`
   Re-expresses fix hunk `@@ -234,7 +234,14 @@ ... handle_field_pattern_match` (added "Marks the ADT live if its variant appears as the pattern ... self.check_def_id(adt.did())").
2. `handle_tuple_field_pattern_match` – removed the same call.
   Re-expresses hunk `@@ -254,7 +261,11 @@` ("Marks the ADT live if its variant appears as the pattern").
3. `visit_pat_expr` – removed the `if let ty::Adt(adt, _) = node_type(..) { check_def_id(adt.did()) }` block.
   Re-expresses hunk `@@ -635,6 +608,11 @@ visit_pat_expr` ("mark the type of variant live when meeting E::V in expr").
4. `check_impl_or_impl_item_live` – restored the legacy "function may construct Self" shortcut: an assoc fn without self receiver of a public local trait is live.
   Re-expresses hunk `@@ -494,38 +480,25 @@ ... ` which deleted the "FIXME: legacy logic ... implicit_self None && visibility(trait_def_id).is_public() => return true". (1.99.1 restructured the function, so the block is re-added after the trait-live check. The other removed parts of that hunk/hunk 3 do not exist in 1.99.1 form; the `rustc_trivial_field_reads` on Default is in library/ and was not touched.)
