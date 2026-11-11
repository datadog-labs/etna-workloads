# Adapted injection for refactor(resolve): clean up the early error return caused by non-call

Fix: https://github.com/rust-lang/rust/commit/7c1bc0353b8c13edc6e3cb8e0a37e876f06da7b7

# Rationale
File: compiler/rustc_resolve/src/late.rs, closure `report_errors_for_call` in `smart_resolve_path_fragment`.
Re-adds the early return removed by the fix hunk `@@ -3528,10 +3528,6 @@ impl<'a: 'ast, ...> LateResolutionVisitor`:
```
-            if !source.is_call() {
-                return Some(parent_err);
-            }
```
Non-call paths (e.g. `HashMap::new;`) again skip the candidate/import suggestions.
