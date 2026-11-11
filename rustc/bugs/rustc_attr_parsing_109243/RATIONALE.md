# Adapted injection for The name of NativeLib will be presented

Fix: https://github.com/rust-lang/rust/commit/d5558e67ef86bda546eca72778aeeeda24420926

# Rationale
File: compiler/rustc_attr_parsing/src/attributes/link_attrs.rs, LinkParser::parse (the `let Some((name, _name_span)) = name else {..}` block).
In 1.99.1 the code from fix hunk `@@ -337,10 +336,16 @@ impl<'tcx> Collector<'tcx>` in rustc_metadata/src/native_libs.rs moved here.
The fix replaced `} else if name.is_none() { sess.emit_err(errors::LinkRequiresName{..}) }` (which was reached only on some paths, so
`#[link(kind="static", modifiers=...)]` without name gave no error and led to unnamed libs) with an unconditional
`let Some((name, name_span)) = name else { emit_err(LinkRequiresName); continue; }`.
Re-injected: the LinkRequiresName error is suppressed when `modifiers` is present, so the attribute is silently dropped with no error.
