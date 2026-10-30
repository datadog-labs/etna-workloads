The reproducer sends `HSETEX k PX 100000 FIELDS 1 f v extra` — a `numfields`
of 1 but an extra trailing token that makes the actual field/value count not
match. It also sends a second malformed call, `HSETEX k PX 100000 FIELDS 2 f
v`, which claims 2 fields but supplies only one field/value pair.

On the clean 9.0.7 build, `hsetexCommand`'s field-count check
(`num_fields > LLONG_MAX / 2 || (num_fields * 2) != (c->argc - fields_index)`)
rejects both calls with `ERR numfields should be greater than 0 and match the
provided number of fields`, and the key is never created (`EXISTS k` -> `0`).

`injection.patch` replaces that check with
`num_fields != (c->argc - fields_index) / 2`, which uses integer division and
so silently accepts a mismatched/odd argument count. This lets the command
proceed to parse fields past the end of the actual argument list, reading
out-of-bounds `robj*` pointers from `c->argv` and dereferencing garbage
memory. On the buggy build the server segfaults (observed as a crash in the
server log / connection refused for subsequent commands), rather than
returning the expected numfields error.
