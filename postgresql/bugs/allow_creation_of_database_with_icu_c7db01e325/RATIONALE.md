# Rationale

Re-introduces the bug: ICU databases can be created with an encoding ICU doesn't support (e.g. SQL_ASCII).

1. `src/backend/commands/dbcommands.c`, `createdb()`: removed the `is_encoding_supported_by_icu(encoding)` check (with its "encoding ... is not supported with ICU provider" error) in the `COLLPROVIDER_ICU` branch. Traces to the dbcommands.c hunk of fix.patch.
2. `src/bin/initdb/initdb.c`: removed `check_icu_locale_encoding()` and its call at the end of `setup_locale_encoding()`. Traces to the initdb.c hunks of fix.patch. I did not revert the "default encoding has been set to" printf, which is cosmetic.

Failing oracle cases: see below (from the oracle run).

- src/bin/initdb|t/001_initdb.pl|fails for encoding not supported by ICU: exit code not 0
- src/bin/initdb|t/001_initdb.pl|fails for encoding not supported by ICU: matches
- src/bin/initdb|t/001_initdb.pl|fails for invalid collation argument: matches (a downstream effect of the same change)
- src/bin/scripts|t/020_createdb.pl|fails for encoding not supported by ICU: matches
