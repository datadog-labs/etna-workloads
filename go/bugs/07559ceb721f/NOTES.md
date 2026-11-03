repro.sh builds the issue59174 test program (negative-size make + append of make(...)...).
Clean toolchain compiles it (exit 0). Buggy toolchain hits an internal compiler error
("'p': not lowered: ... Zero SSA PTR SSA") because isInlinableMemclr accepts a negative size.
