# Adapted injection for Suggest considering casting fn item as fn pointer in more cases

Fix: https://github.com/rust-lang/rust/commit/4203627cedc5a6b5a7b7605888b5c33876e2b0e2

Fix added: suggestion of fn-pointer casting when types are not both fn types (Sorts error) and in trait-impl-mismatch help.
1. rustc_trait_selection/src/error_reporting/infer/suggest.rs, `suggest_function_pointers`: removed
   `else if let TypeError::Sorts(exp_found) = terr { self.suggest_function_pointers_impl(None, &exp_found, diag); }`
   (fix hunk `@@ -476,6 +488,23 @@` adding the wrapper with the Sorts branch). Only the fn/fn case remains (old behaviour).
2. traits/fulfillment_errors.rs: removed `self.suggest_function_pointers_impl(None, &exp_found, err);`
   (fix hunk `@@ -1969,6 +1969,7 @@`).
