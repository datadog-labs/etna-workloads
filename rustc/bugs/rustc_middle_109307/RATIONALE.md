# Adapted injection for Ignore `Inlined` spans when computing caller location.

Fix: https://github.com/rust-lang/rust/commit/be8b32392953c7b5185afab809fa22191d442e10

# Rationale
Hunk: compiler/rustc_middle/src/mir/mod.rs, `Body::caller_location_span`: for a non-`#[track_caller]` inlined callee it now calls `from_span(callsite_span)` instead of `from_span(source_info.span)`.

Re-expresses the fix's hunks in block.rs (`@@ -1482,7 +1482,11 @@ ... span_to_caller_location`, "Remove `Inlined` marks as they pollute `expansion_cause`") and caller_location.rs (`location_triple_for_span`). Those hunks stripped the `Inlined` hygiene marks from the span before `expansion_cause`, so inlining did not change the reported location.

In 1.99.1 there are no `Inlined` hygiene marks. The `ExpnKind::Inlined` machinery and `fresh_expansion` are gone, and inlining is tracked by `SourceScope.inlined`. So hygiene.rs's `fresh_expansion` hunk has no counterpart. The fix's code paths no longer exist, so this is an adaptation, not an exact reversal. The buggy behaviour that comes back is that inlining leaks into the caller location. The location then comes from the inline call site instead of the macro-expanded span inside the inlined function.
