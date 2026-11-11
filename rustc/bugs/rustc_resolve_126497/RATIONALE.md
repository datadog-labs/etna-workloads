# Adapted injection for delegation: Fix hygiene for `self`

Fix: https://github.com/rust-lang/rust/commit/cbc3bdbe01990773a90f72260ce2a4b1c778e554

# Rationale
File: compiler/rustc_resolve/src/late.rs, fn `resolve_delegation`.
Re-expresses the hunk `@@ -3281,17 +3281,19 @@` of late.rs, which wrapped the `self` binding and body visit in
`self.with_rib(ValueNS, RibKind::FnOrCoroutine, |this| {...})`. The buggy parent had no such rib: `self` was bound
in the enclosing (current innermost) value rib, so a `self` coming from a macro resolved (hygiene bug).
Now the `self` binding (ident span from the last path segment, as in the parent) is inserted into the current innermost rib
without the FnOrCoroutine rib; the label/lifetime ribs around `visit_block(body)` are kept.
The diagnostics.rs hunks (message wording) were not reverted; they only affect labels, and the test fails on resolution anyway.
