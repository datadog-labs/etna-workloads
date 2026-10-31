Reproducer: resizes a shared anonymous mmap (mmap(-1, n)) up, and down then back up.
Clean: Linux forbids expanding a shared anonymous mapping, so resize raises ValueError.
Buggy: resize succeeds ("resized 8192"), which can lead to a bus error on access.
