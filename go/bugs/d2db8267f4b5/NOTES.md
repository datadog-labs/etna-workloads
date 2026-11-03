repro.sh builds a file with -gcflags=-lang=go1.20 containing `G(F[int])`, where F[P any, Q *P] is
partially instantiated and passed as an argument. Q is inferable from the constraint.
Clean: compiles (exit 0), since for -lang < go1.21 types2 still infers type arguments from constraints.
Buggy: error "implicitly instantiated function as argument requires go1.21 or later" (exit 1).
