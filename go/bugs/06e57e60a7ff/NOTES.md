repro.sh compiles a file with `-gcflags=-lang=go1.25` containing invalid new(expr) calls
(undefined name, untyped nil, generic type without instantiation, comparable, no-value call).
Clean: only the real errors. Buggy: spurious "new(expr) requires go1.26" version errors
on top of some of them, and missing errors for new(nil), new(G), new(comparable).
