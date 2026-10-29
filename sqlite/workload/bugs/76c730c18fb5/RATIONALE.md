# Rationale

Fix (ticket #1669, func.c `sumFinalize`): an integer SUM that overflows now
throws "integer overflow" instead of silently returning `(i64)p->sum`.

In 3.54.1 the same check lives in `sumFinalize` as the `p->ovrfl` branch that
calls `sqlite3_result_error(context,"integer overflow",-1)`. I replaced it with
`sqlite3_result_int64(context, sqlite3RealToI64(p->rSum+p->rErr))`. That is the
pre-fix behaviour: the overflowed running sum is cast to i64 and returned as an
integer. `sqlite3RealToI64` is the saturating cast, used because a raw cast of
an out-of-range double is undefined behaviour. `total()` is unchanged.

Oracle cases that fail (test/func.test): func-18.12 (expects error
"integer overflow", gets a number), plus the related overflow cases func-18.15,
func-18.18, func-37.100, func-37.110 and func-37.120.
