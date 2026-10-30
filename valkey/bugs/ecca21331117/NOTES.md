# NOTES

`repro.sh` starts a single `valkey-server` and issues three malformed hash
field-expiration commands that each end with `FIELDS` but no numfields
argument and no field list:

```
HSETEX myhash KEEPTTL KEEPTTL KEEPTTL FIELDS
HEXPIRE myhash 10 NX NX FIELDS
HGETEX myhash PERSIST PERSIST FIELDS
```

followed by a `PING` to confirm the server is still alive.

This is a direct translation of the upstream test case "Verify error when
hash expire commands num fields is not provided" added by `fix.patch`
(`tests/unit/hashexpire.tcl`).

## Root cause

`fix.patch` changes the loop bound in `hsetexCommand`, `hgetexCommand` and
`hexpireGenericCommand` in `src/t_hash.c` from `fields_index < c->argc` to
`fields_index < c->argc - 1`. When the command's last argument is the
`FIELDS` keyword itself (no numfields token after it), the buggy (off-by-one)
version lets `fields_index` reach `c->argc`, so the code goes on to read
`c->argv[c->argc]` / `c->argv[c->argc + 1]`, an out-of-bounds access past the
end of the argv array.

## Observed difference

- **clean build**: all three commands return the expected error
  `ERR numfields should be greater than 0 and match the provided number of
  fields`, and the trailing `PING` returns `PONG`.
- **buggy build**: `HSETEX` and `HEXPIRE` still return the same error, but
  `HGETEX myhash PERSIST PERSIST FIELDS` corrupts/crashes the server (reading
  past argv), so the connection drops and the server process segfaults; the
  final `PING` fails to connect instead of returning `PONG`.
