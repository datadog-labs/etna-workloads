# Adapted injection for Don't type error if we fail to coerce Pin because it doesnt contain a ref

Fix: https://github.com/rust-lang/rust/commit/9455373d203addf6f34fc8ee25a9ee5211314dcb

# Rationale
File: compiler/rustc_hir_typeck/src/coercion.rs, fn `Coerce::coerce` (target-type match).

1.99.1 had refactored the fix (`coerce_pin_ref` + fallthrough via `commit_if_ok`) into
`maybe_to_pin_ref` guard arm `_ if let Some(..) = self.maybe_to_pin_ref(a,b)`, which falls through
to unify when the source isn't a ref. I re-expressed the pre-fix behaviour: for any `Pin<_>` target
(pin_ergonomics on), the result of the pin coercion is returned unconditionally, and
`Err(TypeError::Mismatch)` is returned when it doesn't apply, instead of falling through to
subtyping. This corresponds to the fix hunk `@@ -230,7 +232,10 @@` which replaced
`return self.coerce_pin(a, b);` with `if pin_coerce.is_ok() { return pin_coerce; }`.
Result: `Pin<Box<()>>` -> `Pin<Box<()>>` yields a type error.
