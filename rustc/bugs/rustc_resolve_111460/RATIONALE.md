# Adapted injection for Improve error for `self: Box<self>`

Fix: https://github.com/rust-lang/rust/commit/3851a4bb914f74fb3f1d7394479ad810deb653cd

# Hunk: compiler/rustc_resolve/src/ident.rs (resolve_ident_in_lexical_scope, RibKind::ConstantItem arm)
Removed the arm `None if rib_ident.name == kw::SelfLower => (span, LowercaseSelf)`.
Re-expresses fix hunk `@@ -1127,28 +1126,25 @@` in ident.rs which added
`None if rib_ident.as_str() == "self" => (span, LowercaseSelf),`. Without it, `Box<self>` gets the generic
"attempt to use a non-constant value in a constant" error with the let/const suggestion instead of the `try using Self` one.
The diagnostic struct/ftl/ResolutionError variant remain (now unused by this path), mirroring the pre-fix absence.
