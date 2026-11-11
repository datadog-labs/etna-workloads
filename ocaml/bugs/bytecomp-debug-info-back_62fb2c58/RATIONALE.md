# Rationale

Fix reversed: PR#6920 (`@@Pdirapply/Prevapply` need debug "after" event).

## Hunks
1. `ocaml/lambda/translprim.ml`, `primitive_needs_event_after`: `Apply | Revapply` now return `false`
   (no after-event). Reverses fix hunk `@@ -640,7 +640,8 @@ let primitive_is_ccall` in bytecomp/translcore.ml, which added
   `Pdirapply _ | Prevapply _` to the ccall-like primitives. In today's code that logic lives here.
2. `ocaml/typing/typecore.ml`, `Pexp_apply`: the two rewrite cases for `%apply`/`%revapply` are guarded with `false &&`.
   In 2015 typecore had no such rewrite, so `f @@ x` reached the primitive path. Today the rewrite turns it into a plain
   application, which bypasses hunk 1, so this is needed for the reverted behaviour to be reachable. (Supporting change, not a fix hunk.)

## Commands
`make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
Result: pr6920_why_at and pr6920_why_swallow fail (backtrace shows "Called from unknown location"/missing frames).
