Reproducer: `repro.sh` writes test/fixedbugs/issue72090.go (made deterministic by sorting
the output) and builds it with `$GO build -trimpath`, then runs it.

The injection removes the inline-position-based recursion check in `canInlineCallExpr`.
With the mutually recursive iter.Seq closures (allStrings/allSuffixes), the buggy compiler
inlines recursively without end and the compile hangs (script reports "compiler hung
(timed out)" after 120s, exit 1). The clean compiler builds in ~10s and the program
prints the sorted strings.
