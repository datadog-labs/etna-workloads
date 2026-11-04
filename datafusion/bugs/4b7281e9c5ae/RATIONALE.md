# Rationale

Fix hunk reversed: `datafusion/expr/src/type_coercion/functions.rs`, `get_valid_types`,
`TypeSignature::Numeric` arm. The fix added an `else if !logical_data_type.is_numeric()`
check on the final common type, returning a plan error. In 55.2.0 the same check exists
(with the message `Function '{function_name}' expects Numeric but received ...`) after the loop.
I removed that trailing `else if` branch.

Why equivalent: the loop only validates `current_types[1..]`; the first argument is never
checked, so with the trailing check gone a single non-numeric argument (e.g. `abs('foo')`)
passes coercion untouched, exactly as before the fix. Messages are worded differently in
55.2.0, but the removed code is the same defect.

Oracle: `math.slt` cases `abs('foo')`, `abs('-1.2')`, `abs(arrow_cast('-1.2','Utf8'))`
expect a planning error for non-numeric input; with the bug the error is no longer
raised at coercion (a different error or result surfaces). See check.sh output for exact result.

check.sh result: math.slt fails (1 of 1 oracle files). The reported output is truncated to
failures 5-8, which are `c*/0` / `c*%0` / `c*0` column-type mismatches (I vs R) that I did not
trace to this change and which may be unrelated to it. The abs failures (the ones this
change targets) were not visible in the truncated output, so I have not confirmed them.
