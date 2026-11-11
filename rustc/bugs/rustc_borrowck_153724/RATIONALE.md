# Adapted injection for Show named lifetime in closure upvar diagnostics instead of synthetic '1

Fix: https://github.com/rust-lang/rust/commit/99e1940adb9083a012aa4e651555c794cc22994f

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/region_name.rs
- Removed `give_name_if_we_can_match_upvar_args` (fix hunk `@@ -372,6 +372,119 @@ impl<'tcx> MirBorrowckCtxt`, which added that whole function).
- In `give_name_if_anonymous_region_appears_in_upvars`, removed the call that tries `give_name_if_we_can_match_upvar_args` before synthesizing `'1` (second fix hunk, which added that call). Upvar regions are again always named with synthetic `'1`.
