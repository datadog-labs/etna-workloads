`for range maxUint` (no iteration variables) with an untyped constant that overflows int.
Clean toolchain reports "cannot use maxUint ... as int value in range clause (overflows)".
The buggy toolchain skips the check (injection removes `check.assignment(&x, nil, "range clause")`
for the no-variable case), so it accepts or mishandles the program instead of giving that compile error.
