# Rationale
The upstream fix (opt_context.cpp/.h hunks) made get_lower/get_upper and the vector getters
return the exact irrational algebraic optimum (via get_exact / to_exprs(n, exact, es)) instead of
the rational bracket. In today's code that logic lives in src/opt/opt_value.cpp:
- `objective_value::to_exprs` (traces to the to_exprs hunk + opt_context.h get_lower/get_upper vector hunks):
  the finite entry is again always the rational bracket `mk_numeral(r, r.is_int())`, never the exact algebraic value.
- `objective_value::to_expr` (traces to the get_lower/get_upper scalar hunks): `algebraic` forced to false,
  so the scalar getters return the rational bracket instead of the exact algebraic numeral.
Result: opt_bounds fails (assertion at test/opt_bounds.cpp:657, algebraic-ness mismatch).

Final check.sh output:
BUILD OK
FAIL opt_bounds (rc=114) ... ASSERTION VIOLATION opt_bounds.cpp:657
