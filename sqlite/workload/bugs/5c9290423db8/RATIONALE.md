# Rationale

Fix hunk (src/pragma.c): `if( bStrict ){ goto doError }` became
`if( bStrict && pCol->eCType!=COLTYPE_ANY ){ goto doError }else{ report row }`,
so a NULL in a NOT NULL column of type ANY in a STRICT table is still reported.

In 3.54.1 the code was restructured (`doTypeCheck`, `labelError`, `labelOk`).
For an ANY column in a STRICT table `doTypeCheck` is false, and the NOT NULL
branch of `sqlite3Pragma` (PRAGMA integrity_check) falls through to the common
`integrityCheckResultRow`. I re-added the pre-fix behaviour: when `bStrict` and
no type check is coded, the NULL branch jumps to `labelOk` (the old
unconditional `if( bStrict ) goto doError`, which skipped the report for ANY
columns) instead of falling through to report the row.

Oracle: strict2-3.0 fails (expected `NULL value in t1.id`, got `ok`). All other
oracle cases pass.
