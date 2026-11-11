# Rationale
One hunk, `ocaml/runtime/obj.c`, in `obj_update_tag`. Before the CAS it now forces the expected header's tag to `Lazy_tag`.

This reverses the fix hunk `@@ -55,30 +55,33 @@ CAMLprim value caml_obj_set_tag` in byterun/obj.c. In the old code, `caml_obj_make_forward` built the expected header as `hd_lazy` with `Lazy_tag` forced in. The CAS therefore failed whenever the real tag wasn't Lazy. The fix changed it to CAS on the actual header. The function was renamed and reworked since, so the same bug is re-expressed in today's shared `obj_update_tag`. With several domains alive, `Forcing -> Forward` (and `Forcing -> Lazy`) never succeeds, so the thread spins forever. A lazy forced in a spawned domain, as in lazy2.ml, hangs.

Commands run:
- `make clean && make -j8 && make -j8 ocamltest` built fine.
- `sh run-oracle.sh` hung on lazy2 (not passed). I killed it at my timeout, so the log has no "failed" line.
- Compiling lazy2.ml by hand and running it under `timeout 10` was killed (rc=124), confirming the hang.
