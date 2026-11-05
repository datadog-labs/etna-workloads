# Rationale

File: src/backend/executor/spi.c, function `_SPI_execute_plan`.

Both hunks trace to the fix_impl.patch hunks that introduced the derived `allow_nonatomic`
(`options->allow_nonatomic && !_SPI_current->atomic`). In today's code the variable also has
`&& !IsSubTransaction()`, so the old code is re-expressed by not using the derived value:

1. Snapshot handling (`if (!options->read_only && !allow_nonatomic)`) now tests
   `options->allow_nonatomic` directly, ignoring whether the SPI connection is atomic. This
   matches the `-`/`+` hunk at that line in fix.patch.
2. ProcessUtility context selection now uses
   `!_SPI_current->atomic && options->allow_nonatomic` again, as in the pre-fix
   `_SPI_current->atomic || !options->allow_nonatomic` test, instead of the derived variable.

With these, snapshot management in an atomic context (a stable function called from CALL's
argument list) behaves as in the buggy version. The derived variable is still computed but no
longer used.

Failing oracle case: src/pl/plpgsql/src||plpgsql_call
