# Rationale

Hunk: `setGenericCommand` in src/t_string.c. The fix changed `getGenericCommand(c);` to
`if (getGenericCommand(c) == C_ERR) return;` so SET ... GET stops on a wrong-type key.
In 9.0.7 the check is `if (getGenericCommand(c) == C_ERR) goto cleanup;`. I reverted it to a bare
`getGenericCommand(c);`, which ignores the error. SET then overwrites the non-string key.

Failing oracle case: "Extended SET GET with incorrect type should result in wrong type error".
The WRONGTYPE error is produced, but the list is overwritten, so `rpop foo` fails.
