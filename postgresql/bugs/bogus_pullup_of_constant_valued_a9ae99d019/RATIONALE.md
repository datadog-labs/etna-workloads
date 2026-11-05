# Rationale

File: src/backend/optimizer/prep/prepjointree.c, function pull_up_constant_function().

Traces to the fix.patch hunk that added the "If the function's result is not a scalar, we punt"
checks. I removed the `funccolcount != 1` check and the `get_expr_result_type()` /
`TYPEFUNC_SCALAR` check, along with the now-unused local variables (functypclass, funcrettype,
tupdesc). The later-added coldeflist (`funccolnames != NIL`) check sat in the same block, so it
went too. Its funccolcount != 1 guard overlaps with it. The funcapi.h include is still needed
elsewhere, so I left it.

Effect: a constant-valued function returning a composite type is pulled up as though it were a
scalar. The whole composite Const replaces the column Vars, which gives wrong results or errors.

Failing oracle case: src/test/regress||join
