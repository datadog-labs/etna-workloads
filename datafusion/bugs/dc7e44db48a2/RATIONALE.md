# Rationale

Fix: #15242, "Unconditionally wrap UNION BY NAME input nodes w/ Projection".

## Change
`datafusion/expr/src/logical_plan/plan.rs`, `Union::rewrite_inputs_from_schema`:
re-added the early `continue` that skips wrapping an input in a `Projection`
when its schema has the same number of fields as the derived union schema.
This reverses the fix hunk that removed that predicate. The rest of the fix
(`try_new_with_schema`, order-of-inputs schema, nullability by occurrence)
is already in 55.2.0 and is left alone.

Same-width inputs whose columns are in a different order are therefore passed
through unprojected. Union is positional at execution, so columns get matched
by position instead of by name.

## Oracle failures (`union_by_name.slt`)
The new regression cases from the fix fail with swapped columns, e.g.
`select x, y, z from t3 union all by name select z, y, x from t3` returns
`c b a` where `a b c` is expected. Lines 319, 325, 331 and 337 fail the same
way, and `select t3.x ... union by name select t3.z, t3.y, t3.x, 'd'` fails too.
