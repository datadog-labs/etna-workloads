# Adapted injection for Fix: Prevent macro-expanded extern crates from shadowing extern arguments

Fix: https://github.com/rust-lang/rust/commit/0748492e2bb7d48c4c548729b0593c470bc31155

# Rationale
compiler/rustc_resolve/src/imports.rs, finalize_import (~line 1451): removed `&& !this.issue_145575_hack_applied` from `if res != initial_res && ...` before `span_bug!("inconsistent resolution for an import")`.
Re-expresses fix hunk `@@ -1170,7 +1170,7 @@` in imports.rs, which added `&& !this.issue_145575_hack_applied` to that check. The flag and its setting in ident.rs/lib.rs already exist in 1.99.1 (and the other import checks use it), so only this check is reverted to the buggy behaviour (ICE).
