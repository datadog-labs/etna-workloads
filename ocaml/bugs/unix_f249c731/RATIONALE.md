# Rationale
Hunk: ocaml/otherlibs/unix/getaddrinfo.c, in unix_getaddrinfo. The early exit for C-unsafe strings (embedded NUL) now uses `return Val_emptylist;` instead of `CAMLreturn (Val_emptylist);`. The function has CAMLparam/CAMLlocal roots registered, so a plain return leaves them on the local roots stack and the GC crashes later.
Reverses fix.diff hunk `@@ -65,7 +65,7 @@ CAMLprim value unix_getaddrinfo(...)`. Today's code returns Val_emptylist rather than Val_int(0), which is the same value.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`. getaddrinfo.ml fails (segfault, exit -11) in bytecode and native.
