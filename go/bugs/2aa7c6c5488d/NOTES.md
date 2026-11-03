repro.sh builds a function that computes NaN from constants (0/0, 0*Inf, Sqrt(-1)) with `-gcflags=-S` and prints the DIVSD/MULSD/SQRTSD instructions.

Clean toolchain: the NaN-producing operations are left to run at runtime, so all three instructions appear. Buggy toolchain: the compiler constant-folds them into NaN constants, so none appear and the output is empty.

Runtime output on amd64 is identical (the folded NaN has the same bits as the hardware NaN), so the difference is visible only in the generated assembly. Use a fresh GOCACHE, because the two toolchains share a version string.
