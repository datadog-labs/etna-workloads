Compiles a package whose initializer declares a large heap-escaping array in unreachable code (after an infinite `goto`).
Clean toolchain compiles it (exit 0). Buggy toolchain hits an ICE "invalid heap allocated var without Heapaddr" in DWARF generation.
