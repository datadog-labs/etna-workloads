repro.sh compiles the issue74473 loop (`for { if i >= len(s) { break }; _ = s[i]; i++ }`)
with `-d=ssa/prove/debug=1` and prints the prove diagnostics.

go-clean reports "Induction variable: limits [0,?), increment 1" and "Proved IsInBounds".
go-buggy assumes Succs[0] is always the loop body, so it misses the induction variable
and the bounds-check proof. It prints nothing (grep exits 1).

The script uses a private GOCACHE (.gocache) because a shared cache hides the difference.
