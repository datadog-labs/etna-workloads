repro.sh writes a file whose `f2() (*t, error)` does `return t{}.M()` (M undefined) and builds it with `-gcflags=-e`.
Clean: only "t{}.M undefined". Buggy: also reports a spurious "not enough return values / have (unknown type)" error.
