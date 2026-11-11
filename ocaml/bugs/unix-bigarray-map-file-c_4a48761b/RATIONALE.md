# Rationale
Bigarray is now in stdlib, so the C name clash can't recur literally. I re-introduced the other
behaviour the fix's new tests guard: Unix.map_file must raise Unix_error on errors.
fix.diff's bigarray-flavoured variant used `MAP_FILE_ERROR() caml_sys_error(NO_ARG)`, whereas the Unix
variant used `uerror("map_file", Nothing)`. That is in the hunk `@@ -38,21 +38,30 @@` of otherlibs/unix/mmap.c
(the `#ifdef IN_OCAML_BIGARRAY` block).
Change: ocaml/otherlibs/unix/mmap_unix.c, in caml_unix_map_file, the fstat failure and the mmap
failure now call `caml_sys_error(NO_ARG)` instead of `caml_uerror("map_file", Nothing)`. Errors
become Sys_error rather than Unix_error (EBADF / EACCES cases of the mapfile test).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/lib-bigarray-file/mapfile.ml fails
(Fatal error: exception Sys_error("Permission denied")).
