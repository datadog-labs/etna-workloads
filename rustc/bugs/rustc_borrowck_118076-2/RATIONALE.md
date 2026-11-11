# Adapted injection for Tweak `.clone()` suggestion to work in more cases

Fix: https://github.com/rust-lang/rust/commit/03c88aaf218f3798e1b9ed98f18f57741d368132

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/mod.rs, in the move-error "clone" suggestion (inside the `if let Some(clone_trait)` block).
The fix hunk `@@ -1135,11 +1135,25 @@` replaced a plain `.clone()` suggestion with, when the moved place has a Deref projection, the fully-qualified `<{ty} as Clone>::clone(&...)` multipart suggestion. In 1.99.1 this is `let sugg = if has_deref {... <{ty} as Clone>::clone(&...) } else { vec![(move_span.shrink_to_hi(), ".clone()")] }`. I collapsed it to always `vec![(move_span.shrink_to_hi(), ".clone()".to_string())]`, restoring the pre-fix behaviour (suggesting `.clone()` through auto-deref, which can clone the reference).
