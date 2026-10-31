Reproducer checks that multi-digit `%`, `divmod` remainder and 3-arg `pow` results that are small ints
are the cached singletons (`is`). Clean prints True for all; buggy prints False
because the x_divrem remainder is no longer passed through maybe_small_long.
