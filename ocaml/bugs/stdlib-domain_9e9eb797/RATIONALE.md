# Rationale
Hunk: ocaml/runtime/domain.c, `handshake_success`: `p->unique_id = domain_self->interruptor.unique_id;` -> `domain_self->id`.
Reverses fix.diff hunk `@@ -337,8 +346,7 @@ CAMLprim value caml_domain_spawn(value callback)` (spawn returning
`p.unique_id` instead of the reusable slot id `p.newdom->id`), i.e. Domain IDs returned by spawn are again
reusable slot ids rather than unique ones. (Today's runtime already has unique ids, so only the spawn-returned id is reverted.)
Other fix hunks (interrupt routing, critical section in domain.ml) not reverted.
Commands: `cd ocaml && make clean && make -j8 && make -j8 ocamltest; cd ..; sh run-oracle.sh`
Result: tests/parallel/domain_id.ml fails (Assert_failure domain_id.ml line 21: get_id d1 <> get_id d3).
