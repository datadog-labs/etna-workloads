# Adapted injection for fixes #121331

Fix: https://github.com/rust-lang/rust/commit/1a81a941ad62f6a619789eb67903121622488209

# Rationale
File: compiler/rustc_resolve/src/check_unused.rs, `Resolver::check_unused` (end of function).
The fix added, in the loop over `potentially_unnecessary_qualifications`, a skip
(`if let ... = unn_qua.binding && (is_unused_import(..) || is_redundant_import(..)) { continue; }`)
from hunk `@@ -514,8 +515,59 @@ impl Resolver<'_, '_>`, so `unused_qualifications` is not emitted when the
qualified item's binding is an unused/redundant import (#121331). I removed that skip so the
lint is always emitted (pre-fix behaviour: conflicting fixes for unused_imports and unnecessary qualification).
The now-unused helper fns are marked `#[allow(dead_code)]` to keep the build warning-free.
