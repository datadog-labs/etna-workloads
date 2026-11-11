Changed src/src/util/mpz.cpp (hunks of FIX.diff for mpz.cpp):
- display_binary_data: reverted to 32-bit `unsigned val/numBits` (1u shifts, 32-bit padding threshold), undoing the fix's uint64_t widening.
- display_bin: small-value branch reverted to `is_uint(a)` / `get_uint`, undoing `is_small`/`get_uint64`. Values that are small but not uint now take the big-number path, and 64-bit digits are truncated to 32 bits: same bug as #3559.

Final ./check.sh output:
BUILD OK
FAIL z3test:smt2/3559.smt2 (rc=139)  (expected "unsat", z3 segfaulted)
