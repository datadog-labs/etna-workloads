# Rationale

Fix hunk reversed: `simplify_concat_ws` in `datafusion/functions/src/string/concat_ws.rs`.
The fix wrapped the empty-delimiter case so that when `simplify_concat` returned
`ExprSimplifyResult::Original`, it was replaced with a `Simplified` `concat(args)` call.
Without it, `concat_ws('', ...)` returned `Original(args)` — the argument list
without the delimiter — to the `concat_ws` UDF, which then treated the first
argument as the separator (the pre-fix behaviour).

Change: the empty-delimiter arm is again `Some(delimiter) if delimiter.is_empty() => simplify_concat(args.to_vec())`.
The now-unused `use crate::string::concat;` import was removed (the fix added it).

Oracle failure: `expr.slt` fails.
`SELECT concat_ws('', a, b, 'c') from foo` gives `bac` instead of `abc`
(same for the Utf8View variant).
