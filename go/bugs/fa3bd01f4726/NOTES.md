repro.sh compiles a small file with `go tool compile -race -S` containing two compiler-generated
wrappers that end in a tail call (`main.(*W).F` via an embedded interface, `main.(*S).G` via an embedded pointer).
It prints the number of runtime.racefuncenter / runtime.racefuncexit calls in each wrapper's assembly.
Clean: enter=2 exit=2 (balanced). Buggy: enter=2 exit=0, since the racefuncexit before the tail call is missing.
