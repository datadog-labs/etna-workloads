# Rationale

The fix (#4300) added a `FIELDS` keyword check to `hpersistCommand` and
`httlGenericCommand` in `src/t_hash.c`. 9.0.7 contains both checks, in the
form `strcasecmp(c->argv[fields_index - 2]->ptr, "fields")`. The patch did not
reverse cleanly because it uses `objectGetVal(...)`, which 9.0.7 doesn't.

Changes (both in `src/t_hash.c`):
- `hpersistCommand`: removed the `FIELDS` keyword check and its syntax-error reply. This reverses hunk 1.
- `httlGenericCommand`: removed the same check. This reverses hunk 2. The function serves HTTL, HPTTL, HEXPIRETIME and HPEXPIRETIME.

With the checks gone, argv[2] is never validated. `HPERSIST key a 1 c` is parsed as `FIELDS 1 c` and returns an array instead of a syntax error.

Oracle cases expected to fail:
- "HPERSIST - check for syntax and type errors"
- "HTTL/HPTTL/HEXPIRETIME/HPEXPIRETIME - check for syntax and type errors"

Both expect `ERR syntax error` for `<cmd> myhash a 1 c`.
