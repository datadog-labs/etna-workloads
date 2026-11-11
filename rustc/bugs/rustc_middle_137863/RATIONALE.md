# Adapted injection for Fix pretty printing of unsafe binders

Fix: https://github.com/rust-lang/rust/commit/83fa2faf239b4bcde67eda7adf0a1a10dfca620d

# Rationale
File: compiler/rustc_middle/src/ty/print/pretty.rs, `pretty_print_type`, `ty::UnsafeBinder` arm.
Re-expresses fix hunk `@@ -703,8 +722,9 @@ ... ty::UnsafeBinder(ref bound_ty)`: the fix replaced
`self.wrap_binder(bound_ty, |ty, cx| ...)` (with FIXME "Make this print `unsafe<>` rather than `for<>`")
by `wrap_binder(bound_ty, WrapBinderMode::Unsafe, ...)`. Buggy state restored by passing `WrapBinderMode::ForAll`,
so unsafe binders print as `for<...>`. The WrapBinderMode plumbing remains (it already exists in 1.99.1) but is unused for this case.
