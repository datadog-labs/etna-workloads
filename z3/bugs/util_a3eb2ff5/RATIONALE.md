# Rationale

Hunk: src/src/util/vector.h, `vector::expand_vector`.

FIX.diff has a single implementation hunk in src/util/vector.h: `#if 1` -> `#if 0`. That switched
z3 from the newer `vector` implementation back to the older one. The older one had no
non-trivially-copyable path in `expand_vector`. It always grew storage with `memory::reallocate`,
which relocates elements bytewise.
In today's tree the `#if/#else` is gone and only the newer implementation remains, so the hunk
cannot be reversed literally. I undid its effect instead. The condition
`std::is_trivially_copyable<T>::value` now becomes `true`, so every element type is relocated
with realloc (memcpy) rather than being moved with `uninitialized_move_n` and then destroyed.

Result: for types that are not trivially relocatable, z3 aborts on smt2/6902.smt2
with `free(): invalid pointer`.

Final ./check.sh output:
BUILD OK
FAIL z3test:smt2/6902.smt2 (rc=134)
    1c1,2
    < sat
    ---
    > free(): invalid pointer
    > timeout: the monitored command dumped core
