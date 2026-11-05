# Rationale
Hunk: src/backend/regex/regprefix.c, findprefix(). Traces to the single hunk of fix_impl.patch.
Restored the old behavior: arcs with co >= ncolors (LACONs / lookahead constraints) are skipped
instead of terminating the prefix search (RAINBOW check kept as in current code). Lookahead
constraints are thus ignored, so pg_regprefix() can return a prefix that a lookahead would rule out.

Failing oracle case: src/test/regress||regex
