# Rationale
- File/function: src/backend/utils/adt/dbsize.c, pg_size_bytes() (Part 4, optional exponent).
- Traces to the dbsize.c hunk of fix.patch. Re-added the `exponent` variable and the check rejecting exponents beyond +/-NUMERIC_MAX_PRECISION with "invalid size", i.e. the bogus dependency on NUMERIC_MAX_PRECISION. Valid sizes with large exponents (e.g. '1e1000000 ...' forms accepted by numeric) are now wrongly rejected.

Failing oracle case: src/test/regress||dbsize
