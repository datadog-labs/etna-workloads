# Adapted injection for Fix error span when arg to asm!() is a macro call

Fix: https://github.com/rust-lang/rust/commit/3dd583d5407c1d459c6539a4673e6d329903da66

# Rationale
File compiler/rustc_builtin_macros/src/asm.rs, fn expand_preparsed_asm, the `!parser.errors.is_empty()` branch.
Fix hunk `@@ -596,7 +597,14 @@` introduced `err_sp = if template_is_mac_call { template_span } else { template_span.from_inner(...) }`.
In 1.99.1 this is `span_in_template(err.span)`; I restored the pre-fix line
`let err_sp = template_span.from_inner(InnerSpan::new(err.span.start, err.span.end));`, so macro-call templates get bad inner spans again.
(The `template_is_mac_call` binding hunk is still used by other callers of span_in_template, left alone.)
