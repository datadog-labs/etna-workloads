# Rationale

## Hunk 1: src/backend/regex/regc_lex.c, brenext()
Traces to the only hunk of fix_impl.patch. `RETV('*', 1)` became `RET('*')` for the BRE `*` token. The token no longer sets `v->nextvalue`. The parser (regcomp.c, parseqatom) reads `nextvalue` to choose greedy or non-greedy, so it now uses a stale value from the previous token.

## Hunk 2: src/backend/regex/regc_lex.c, lexstart()
This is not in the upstream fix. It sets `v->nextvalue = 0` at lexer start. In the original bug, `nextvalue` was uninitialized stack garbage. That is usually nonzero, so the test passed by luck. Zeroing it makes the stale value deterministic, so `.*b` in BRE mode is parsed as non-greedy and the failure is reproducible. Without this hunk the oracle still passed.

## Failing oracle cases
- src/test/modules/test_regex||test_regex
