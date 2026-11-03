repro.sh compiles a small program (issue 53456's b53456.go) with `-N -l -S` and prints the
line number and opcode of each instruction in (*T).Inc.

The map key is converted for the mapaccess_fast64 call. With the bug, the converted key's
position is copied from the shared ONAME `key`, so the key-load MOVQ is attributed to line 15
(the parameter declaration) instead of line 16 / line 18 (the map index expressions).
The clean toolchain keeps it on 16 and 18. This is what the debugger would show as
stray stepping back to the func line.
