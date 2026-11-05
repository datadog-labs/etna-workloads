# Rationale

Changed hunk: `src/backend/optimizer/path/equivclass.c`, `generate_join_implied_equalities()`.

Traces to the fix_impl.patch hunk at "@@ -1400,10 +1406,23 @@". That hunk made outer joins examine all ECs mentioning anything in nominal_join_relids (`get_eclass_indexes_for_relids`), instead of only ECs mentioning both inputs. My change removes the outer-join branch, so the function always calls `get_common_eclass_indexes(inner, outer)`.

Effect: EC-generated post-join filter clauses (mentioning one input plus the OJ relid) are no longer generated at the outer join. Outer join quals from ECs are therefore mishandled.

The other fix hunks only added the ojrelid parameter (now an sjinfo parameter in current code), plus comments. They don't need reversing to bring the bug back.

Failing oracle case: src/test/regress||join
