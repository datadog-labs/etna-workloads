# Rationale
Re-adds the `env` parameter to `normalize_type` (reverses fix.diff hunks):
- typing/ctype.ml: `normalize_type_rec`/`normalize_type` take `env`, and use it in `is_equal env` instead of `Env.empty` (reverses `@@ -4546,7 +4546,7 @@ let closed_schema`, `@@ -4567,7 +4567,8 @@`, `@@ -4605,11 +4606,11 @@`).
- typing/ctype.mli: `val normalize_type: Env.t -> type_expr -> unit` (reverses `@@ -349,7 +349,7 @@`).
- typing/out_type.ml (formerly printtyp mark_loops): `normalize_type !printing_env ty` (reverses `@@ -923,7 +923,7 @@ let rec mark_loops_rec`; the fix used Env.empty, the bug uses a real env).
- typing/typemod.ml: normalize_modtype/signature/signature_item take env again; type_implementation passes `finalenv` (reverses `@@ -2457,17 +2457,17 @@` and `@@ -2668,7 +2668,7 @@`).
Effect: abbreviations (t = int) are expanded when deduplicating polymorphic variant conjunctive types, so `t & int & string` prints as `t & string`.
Ran: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: tests/typing-misc/normalize_type.ml => failed.
