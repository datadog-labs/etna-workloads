Reproducer folds a Subject with leading space via BytesGenerator and prints the bytes. Buggy interpreter encodes/handles the leading whitespace differently from clean (see check.sh output).
