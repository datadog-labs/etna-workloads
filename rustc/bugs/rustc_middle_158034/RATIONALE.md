# Adapted injection for fix(thir): visit reborrow source expressions

Fix: https://github.com/rust-lang/rust/commit/b8d7dcb0696417e0190e8740ee3d9da8f7a16e54

# Rationale
compiler/rustc_middle/src/thir/visit.rs, `walk_expr`: the `Reborrow { source, mutability: _, target: _ }` arm (which visits the source expr) is changed back to `Reborrow { .. } => {}`.
Re-expresses fix hunk `@@ -187,7 +187,7 @@ walk_expr`: `-        Reborrow { .. } => {}` / `+        Reborrow { source, .. } => visitor.visit_expr(&visitor.thir()[source]),`.
Effect: THIR visitors (e.g. unsafety check) skip the reborrow source, so unsafe calls inside it are missed.
