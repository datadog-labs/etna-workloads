# Adapted injection for Fix error message for calling a non-tuple struct

Fix: https://github.com/rust-lang/rust/commit/ed6a78ca868625faa50c66409037df66bff3e5bd

# Rationale
File: compiler/rustc_resolve/src/late/diagnostics.rs, fn `try_lookup_name_relaxed`, the `call_has_self_arg` branch for `Res::Def(DefKind::Struct, def_id)`.

Re-expresses fix hunks `@@ -823,8 +823,10 @@` (`if self.has_private_fields(def_id) { update_err_for_private_tuple_struct_fields; note }`) and
`@@ -1664,17 +1677,18 @@` (`if self.has_tuple_fields(def_id) { err.primary_message("cannot initialize a tuple struct ...") }`).
In 1.99.1 the equivalent guard is `struct_ctor(def_id)` being Some with private fields and a `CtorKind::Fn` ctor. I removed the CtorKind::Fn check and made a missing ctor
(braced struct such as `Bar {}`) also enter the branch (`is_none_or`), so the "cannot initialize a tuple struct which contains private fields" message is wrongly emitted for a non-tuple struct, as before the fix.
