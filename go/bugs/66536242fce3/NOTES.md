repro.sh compiles a small program (a := 1; runtime.Breakpoint(); sink = a) with `-N -l -S` and prints the
line sequence of main.main's assembly. Clean: 5 6 7 8 9 5. Buggy: 5 6 7 6 8 9 5 — the literal-rewriting
temp assignment gets the variable's declaration position (line 6), so line numbers jump backwards (issue 74576).
