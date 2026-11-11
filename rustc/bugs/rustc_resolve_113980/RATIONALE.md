# Adapted injection for fix(resolve): skip panic when resolution is dummy

Fix: https://github.com/rust-lang/rust/commit/02f1f6a8a893bbaabc87079a61815685b0f88d75

# Rationale
File compiler/rustc_resolve/src/imports.rs, function finalize_import (single-import consistency check).
Fix hunk `@@ -990,7 +990,10 @@`: added `&& res != Res::Err` to the `res != initial_res && ambiguity_errors.is_empty()` span_bug guard.
In 1.99.1 the guard is expressed as an early return `if res == Res::Err || has_ambiguity_error { delayed_bug; return }` before the span_bug. I removed `res == Res::Err ||` so a dummy (Res::Err) resolution reaches the "inconsistent resolution for an import" span_bug again.
