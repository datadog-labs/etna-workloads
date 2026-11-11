# Adapted injection for Don't report bivariance error when nesting a struct with field errors into another struct

Fix: https://github.com/rust-lang/rust/commit/68885216b63f6e75e50b4c0f3c7250ca4ac7afda

File: compiler/rustc_hir_analysis/src/check/wfcheck.rs, fn check_variances_for_type_defn.
1. Removed the deep-error check (`HasErrorDeep` visit of `type_of(def_id)` before `match hir_param.name`). Re-expresses hunk `@@ -1955,6 +1946,15 @@` ("Look for `ErrorGuaranteed` deeply within this type" added by the fix). The HasErrorDeep struct is left in place (unused is not an error here since it is still referenced... see build OK).
2. Restored the shallow check in the Enum/Struct/Union arm: return early only if the item's own fields reference errors. Re-expresses hunk `@@ -1875,24 +1875,15 @@` (fix replaced it with `// Ok`).
Result: a struct nesting another struct with an erroring field gets a spurious bivariance error.
