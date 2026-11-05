# Rationale

## src/backend/regex/regexec.c, cfindloop()
Traces to the single hunk in fix_impl.patch. The fix replaced an early
`return REG_NOMATCH` (when no shorter/longer end remained for the current begin
point) with a `break` out of the endpoint loop, so the next begin point is tried.
I restored the old code: when `cdissect` fails with REG_NOMATCH and there is no
more endpoint to try, the function returns REG_NOMATCH for the whole search
instead of moving on to the next begin position. This makes matches that need a
later start fail (backrefs combined with non-greedy quantifiers).

## Failing oracle cases
- src/test/regress||regex (expected to fail; see oracle run)
