# Rationale
The fix reworked the `value` rule of the class-field grammar so attributes after `val` are kept with the flags (`val[@foo] virtual x : t`, `val![@foo] mutable x`). Today's grammar already has the fixed shape, so I undid the effect in the semantic action only. The virtual-value attributes are now lost.

Hunks (parsing/parser.mly and the matching generated action in boot/menhir/parser.ml, line ~65859):
- Rule `value: no_override_flag attrs = attributes mutable_ = virtual_with_mutable_flag label ...`. The action `(label, mutable_, Cfk_virtual ty), attrs` became `(label, mutable_, Cfk_virtual ty), (ignore attrs; [])`.
  - It reverses the part of the hunk `@@ -1145,38 +1146,39 @@ parent_binder:` that made `val[@foo] virtual ...` and `val![@foo] mutable ...` carry their attributes (`..., $2`). Before the fix, virtual values had no attribute slot in this position.
  - `ignore attrs` is there because the generated parser is compiled with warning 26 as an error.
- I did not touch the `@@ -1122,8 +1122,9 @@ class_field:` hunk or the `method_` hunk. Those are already correct in today's grammar.

Commands:
- `make -j8 && make -j8 ocamltest && sh run-oracle.sh` gave `shortcut_ext_attr.ml => failed`.
- Final `make clean && make -j8 && make -j8 ocamltest`, then `run-oracle.sh`: the test fails. The ocamlc.byte output differs from the reference at the `val ... virtual` attribute.

RESULT: injected
