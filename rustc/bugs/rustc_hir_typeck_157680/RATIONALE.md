# Adapted injection for Require #[pin_v2] for explicit pin-projection patterns

Fix: https://github.com/rust-lang/rust/commit/50b0362bf87c5f5a2d5b73920b0d905bf1b8cc6b

# Rationale
All changes in compiler/rustc_hir_typeck/src/pat.rs.

1. `check_pat_struct` and `check_pat_tuple_struct`: removed the `self.check_pin_projection(pat, pat_ty, pat_info);` calls
   (fix hunks `@@ -1533,6 +1551,8 @@ check_pat_struct` and `@@ -1791,6 +1811,8 @@ check_pat_tuple_struct`). Explicit `&pin mut`/`ref pin` patterns are no longer checked.
2. Removed the `check_pin_projection` function (fix hunk `@@ -1523,6 +1508,39 @@`, "Reject pin-projection through a type that isn't structurally pinnable").
3. `check_pat_inner`, the implicit pin-deref peeling arm: restored the inline `#[pin_v2]` check on `inner_ty` that only runs for match-ergonomics projection
   (reverse of fix hunk `@@ -544,21 +544,6 @@`, which deleted "if the inner_ty is an ADT, make sure that it can be structurally pinned").
