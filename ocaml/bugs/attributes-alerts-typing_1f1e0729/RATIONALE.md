# Re-introduction of the bug fixed by #13170 (floating alerts and Warning 53 across cmis)

The upstream fix moved the "mark floating `[@@@alert]` as used" step out of the
typechecker (where it depended on a `toplevel` flag and on whether W53 was
active) and into the point where the alerts get pulled out to be saved in the
.cmi (`alerts_of_sig/str ~mark:true`). It also cleared the unused-attribute
table in `warn_unused`. I reverted each part, rewritten against today's code:

## driver/compile_common.ml
- `typecheck_intf` no longer calls `alerts_of_sig ~mark:true` and returns only
  `tsg`. `emit_signature` takes `ast` again and works out
  `alerts = Builtin_attributes.alerts_of_sig ast` itself (no marking), and
  `interface` calls it that way.
  Reverses `@@ -52,6 +52,7 @@ let typecheck_intf info ast =`,
  `@@ -62,11 +63,10 @@ let typecheck_intf info ast =` and `@@ -76,9 +76,9 @@ let interface info =`.

## driver/compile_common.mli
- Puts back the old signatures `typecheck_intf : info -> Parsetree.signature -> Typedtree.signature`
  and `emit_signature : info -> Parsetree.signature -> Typedtree.signature -> unit`.
  Reverses `@@ -48,12 +48,13 @@ val with_info :`.

## parsing/builtin_attributes.ml
- `warn_unused`: removes `Attribute_table.clear unused_attrs;`.
  Reverses `@@ -38,6 +38,7 @@ let attr_order a1 a2 =`.
- `alerts_of_sig` / `alerts_of_str`: the `~mark` argument and the
  `mark_alerts_used` call are gone again.
  Reverses `@@ -268,7 +269,10 @@ let rec attrs_of_sig = function` and
  `@@ -276,7 +280,10 @@ let rec attrs_of_str = function`.
- `warning_attribute`/`process_alert`: the `Some _` case goes back to `()`
  (it no longer marks the alert used when W53 is off), and the original
  comment is restored.
  Reverses `@@ -306,15 +313,19 @@ let warning_attribute ?(ppwarning = true) =`.

## parsing/builtin_attributes.mli
- `alerts_of_sig` / `alerts_of_str` no longer take `mark:bool`.
  Reverses `@@ -115,8 +115,8 @@ val check_alerts_inclusion:`.

## typing/typemod.ml
- `transl_signature ?(toplevel = false)` comes back. In it, `Psig_attribute x`
  calls `mark_alert_used x` again when `toplevel || not W53 active`.
  Reverses `@@ -1404,7 +1404,7 @@ and transl_with ...` and `@@ -1706,8 +1706,6 @@ and transl_signature ...`.
- `type_str_item`, `Pstr_attribute x`: the same conditional `mark_alert_used`.
  Reverses `@@ -2868,8 +2866,6 @@ and type_structure ...`.
- `type_implementation`: `alerts_of_str ast` (no marking) is called again inside
  the `if not !Clflags.dont_write_files` block.
  Reverses `@@ -3157,8 +3153,8 @@ let type_implementation ...`.
- `type_interface` calls `transl_signature ~toplevel:true`, and the
  `transl_signature ~toplevel:false` wrapper is back.
  Reverses `@@ -3186,10 +3182,7 @@ let save_signature ...`.

## typing/typemod.mli
- `val transl_signature` is exported again.
  Reverses `@@ -43,8 +43,6 @@ val type_implementation:`.

(`.depend` and `Changes` hunks: not touched. They are build and docs files, not
implementation.)

## Commands and results
- `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
  The build succeeded. 3 tests failed: w53.ml, w53_across_cmi.ml and w53_marshalled.ml (the
  compiler output differs from the reference). The other 30 passed.
- Final check: `make clean && make -j8 && make -j8 ocamltest` (exit 0), then
  `sh run-oracle.sh`. Same result: w53.ml, w53_across_cmi.ml and w53_marshalled.ml
  fail, 30 pass.

RESULT: injected
