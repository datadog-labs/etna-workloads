# Rationale

Fix: `split_part` with an empty delimiter fell through to Rust's `split("")`, which yields leading/trailing empty fields.

In 55.2.0 the logic moved into `append_split_part` (datafusion/functions/src/string/split_part.rs), the generic per-row path, which is also used when all arguments are scalar (as in the slt oracle).

Changes, both in `append_split_part`:
- Positive branch: removed the `delimiter.is_empty()` special case (`(n == 1).then_some(string)`). It now calls `string.split(delimiter).nth(idx)` directly. This reverses the fix's first hunk.
- Negative branch: removed the `delimiter.is_empty()` special case (`(n == -1).then_some(string)`). It now calls `string.rsplit(delimiter).nth(idx)` directly. This reverses the fix's second hunk.

The 55.2.0 code calls the `split_nth`/`rsplit_nth` helpers, which are only a memchr optimisation. The fix's original code called `split`/`rsplit` directly, so I restored that. The helpers are now unused and will give a dead-code warning.

The array-string, scalar-delimiter, scalar-position fast path (`split_part_scalar*`) has its own empty-delimiter handling. I left it alone, so the bug appears only on the generic path.

## Oracle failures (expr.slt)
- `split_part('a,b', '', 1)` returns `` instead of `a,b`.
- `split_part('a,b', '', -1)` returns `` instead of `a,b`.
- `split_part('a,b', '', 2)` returns `a` instead of empty.
- `split_part('a,b', '', -2)` returns `b` instead of empty.
