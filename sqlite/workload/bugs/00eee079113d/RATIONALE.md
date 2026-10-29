# Rationale

Fix hunk (src/func.c, sqlite3RegisterLikeFunctions) added `pDef->funcFlags &= ~SQLITE_FUNC_UNSAFE;`
so that re-registering LIKE (PRAGMA case_sensitive_like) keeps LIKE innocuous.
In 3.54.1 the loop form already exists; I removed that one line in tree/src/func.c.
sqlite3CreateFunc on an existing function keeps/sets SQLITE_FUNC_UNSAFE under
defensive/trusted_schema=OFF, so after the PRAGMA, LIKE in a view is "unsafe".

Oracle failures: like-18.1 and like-18.2 ("unsafe use of LIKE()").
