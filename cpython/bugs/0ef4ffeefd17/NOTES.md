Reproducer: replaces sys.stdout with a fresh StringIO (the only reference), then calls print(X()) where X.__str__ rebinds sys.stdout, dropping the last reference to the stream print is writing to.
Clean: print holds its own strong reference to sys.stdout, so it finishes and the script prints "done" (exit 0).
Buggy: print() drops its reference to sys.stdout right after fetching it, so the stream is freed while in use. The interpreter segfaults (exit -11).
