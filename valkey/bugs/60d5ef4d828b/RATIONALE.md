# Rationale

The fix changed the two EVALSHA NOSCRIPT replies in scripting.c from
`addReply(c, shared.noscripterr)` to `addReplyErrorObject(...)`, so the error
is counted in errorstats / failed_calls / total_error_replies.

In 9.0.7 that code lives in src/eval.c. Reverted both hunks to `addReply`:
- `evalGenericCommand`: evalsha with an unknown hash (fix hunk 1).
- `evalShaCommand`: sha length != 40 (fix hunk 2).

I left the SCRIPT SHOW use at eval.c:663 alone. The fix did not touch it, because it did not exist then.

Oracle: `errorstats: failed call NOSCRIPT error` fails. `errorstat NOSCRIPT`
is empty, where `count=1` was expected, because the error is no longer counted.
