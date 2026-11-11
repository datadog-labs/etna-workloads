# Rationale
- ocaml/runtime/memprof.c, rand_init: removed the `- 1` (and its comment) from `next_rand_geom = rand_geom(domain) - 1;`. Reverses hunk `@@ -1030,7 +1030,9 @@ CAMLprim value caml_memprof_start(...)` (code has since moved into rand_init).
- Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`. Result: statmemprof/alloc_counts.ml fails (minor 170 / 169) in bytecode and native.
