repro.sh compiles a file with `-gcflags=-lang=go1.20` using generic interface `T[P any] interface{}` and calls `f1(t)` / `f2(t, s)`.
Clean: Go 1.20 unification, so f1 infers P=int and f2 reports "type string of s does not match inferred type int for P".
Buggy: interface inference is enabled for pre-1.21 language versions, so it reports "in call to f1, cannot infer P".
