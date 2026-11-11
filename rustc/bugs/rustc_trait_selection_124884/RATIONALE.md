# Adapted injection for place explicit lifetime bound after generic param

Fix: https://github.com/rust-lang/rust/commit/417460027e544b7f034c4d79678b5088279eeb7b

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/region.rs (the code moved from rustc_infer/.../error_reporting/mod.rs), in the "explicit lifetime bound" suggestion code (the `None =>` arm of `bounds_span_for_suggestions`).

Re-expresses fix hunk `@@ -2389,7 +2390,18 @@`. The fix replaced `None => Some((self.tcx.def_span(def_id).shrink_to_hi(), false, None))` with a lookup of the param's `ParamName::Plain(ident)` and `ident.span.shrink_to_hi()`. I removed the ident-based span (the `ParamName::Plain(ident)` branch), so the suggestion again uses `def_span(def_id).shrink_to_hi()`. That span covers the default (`T = i32`), so the suggestion is placed after the default (`T = i32: 'static`). The colon_span handling, which is newer than the fix, is kept.
The fix's other hunks (the import change and the `type_param` local) are cosmetic.
