# Rationale

All changes are in `datafusion/functions-table/src/generate_series.rs`, `GenerateSeriesFuncImpl::call_int64`.
In 55.2.0 the int64 path was split out of `call_with_args`, and the start/end vs. step
direction checks were removed (empty series now), so only two hunks of the fix still apply.

1. Fix hunk "Argument #N must be an INTEGER or NULL" reversed: the loop is back to
   `for expr in exprs` and any non-Null/non-Int64 literal returns the old generic
   `"First argument must be an integer literal"`, which is wrong for arguments 2 and 3.
2. Fix hunk `"Step cannot be zero"` reversed to the old lowercase `"step cannot be zero"`.

(The "Start is bigger than end..." message hunks have no counterpart in 55.2.0; the checks no longer exist.)

## Oracle failures
`table_functions.slt`: the `generate_series('foo','bar')` / `range('foo','bar')` / `range(1,'bar')`
cases expect `Argument #N must be an INTEGER or NULL, got Literal(...)`, and the `step zero`
cases expect `Step cannot be zero`; they now get the old messages and fail.
