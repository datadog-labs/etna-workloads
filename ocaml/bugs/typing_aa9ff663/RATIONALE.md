# Rationale
File: ocaml/typing/typecore.ml, `is_nonexpansive`.
Fix hunk `@@ -1038,6 +1038,8 @@ let rec is_nonexpansive exp` added a `Texp_letmodule` case making `let module M = ... in e` nonexpansive when module and body are. In today's code local modules are `Texp_struct_item (si, e)`, whose case (`is_nonexpansive_struct_item si && is_nonexpansive e`) I removed, moving `Texp_struct_item _` into the always-expansive group. So `let id = let module M = struct end in fun x -> x` is no longer generalized (PR#4838/4511 return).
Only that hunk is reversed; the test and Changes hunks were not touched.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: tests/typing-modules/Test.ml fails (expect output differs).
