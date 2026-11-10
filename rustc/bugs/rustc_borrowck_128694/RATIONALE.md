# Adapted injection for Normalize when equating dyn tails in MIR borrowck

Fix: https://github.com/rust-lang/rust/commit/c6f8672dd5e128766298ed0d53bb32a94188f886

# Rationale
File: compiler/rustc_borrowck/src/type_check/canonical.rs, fn `struct_tail` (called by the PtrToPtr cast check in mod.rs).

Fix hunk: `@@ -2330,10 +2330,16 @@` in type_check/mod.rs. It added `let src_tail = normalize(src_tail);` and
`let dst_tail = normalize(dst_tail);` because `struct_tail_with_normalize` only structurally resolves the type.
In 1.99.1 that logic was refactored into `TypeChecker::struct_tail`, which passes a full-normalizing closure to `struct_tail_raw`.
The re-injection replaces the closure `|ty| self.normalize(ty, location)` with `|ty| ty.skip_norm_wip()`, so the dyn tails are no longer normalized.
The cast check then compares an unnormalized dyn tail (`dyn Generic<<i32 as Trait>::Associated>`) with a normalized one, and rustc ICEs.
