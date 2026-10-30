# Rationale

All changes are in `src/t_stream.c`; each reverses one hunk of fix.patch by turning the `int64_t` locals back into `int`, so `lpGetInteger()` (which returns int64_t) is truncated.

- `streamTrim`: `flags`, `to_skip`, `ms_delta`, `seq_delta` back to `int`. This is the hunk that matters. A large ms delta (for example 1641544570597) overflows `int`, so `currid` is wrong for MINID and the whole rax node is trimmed.
- `streamIteratorGetID`: `lp_count` and `flags` back to `int`.
- `streamIteratorRemoveEntry`: `flags` back to `int`.

The code is otherwise identical to the pre-fix code, apart from the 9.0.7 variable names (`primary_*`).

## Oracle failure
`XTRIM with MINID option, big delta from master record` fails. XRANGE returns an empty list instead of the two surviving entries, because the whole node was trimmed.
