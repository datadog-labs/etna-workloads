# Rationale
File: ocaml/otherlibs/unix/socketaddr.c, function caml_unix_alloc_sockaddr (AF_UNIX case).
Removed the `#if defined(__linux__) || defined(__HAIKU__) (sun_path[0]=='\0') ? path_length :` branch, so
abstract Linux socket paths (starting with NUL) are truncated by strnlen to "". This reverses part of the fix.diff hunk
`@@ -102,25 +102,49 @@ void get_sockaddr(...)` (the "paths may be null-terminated, but Linux abstract sockets start with a null" logic).
Other parts of that hunk (unnamed-socket length check, alloc_unix_sockaddr helper) are left as is.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> recvfrom_linux.ml failed (assertion), recvfrom_unix.ml passed.
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: same result.
