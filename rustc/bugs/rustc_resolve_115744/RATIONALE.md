# Adapted injection for Do not suggest generic const items unless enabled

Fix: https://github.com/rust-lang/rust/commit/daf3c45531815e8015e8a508f2650fcfa166cf29

compiler/rustc_resolve/src/late.rs, resolve_item, `ItemKind::Const` arm (was ~line 2450 upstream).
Fix hunk `@@ -2450,7 +2450,11 @@` replaced `RibKind::Item(HasGenericParams::Yes(generics.span))` with a
`generic_const_items` feature-gated choice between Yes and No. I removed the gate again (always `HasGenericParams::Yes(generics.span)`), so the
"try introducing a local generic parameter" suggestion appears without the feature.
