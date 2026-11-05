# Rationale

Changed `src/src/backend/regex/regexec.c`, functions `ccondissect` and `crevcondissect`.
Traces to the fix.patch hunks in those functions:
- Removed "Reset left's matches" `zaptreesubs(v, left)` after a failed right-side cdissect.
- Re-added `zaptreesubs(v, left); zaptreesubs(v, right);` after choosing a new midpoint.

Effect: the old behaviour is restored. Match data from an abandoned sub-match stays set while
the DFA runs for the next midpoint. A back-reference can then see stale captures and match when it shouldn't.

Failing oracle cases (both FAIL): src/test/modules/test_regex||test_regex, src/test/regress||regex.
