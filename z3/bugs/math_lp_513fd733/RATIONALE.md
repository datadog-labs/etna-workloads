# Rationale
One hunk: src/src/math/lp/bound_analyzer_on_row.h, `limit_j` weighted explanation closure:
`consume(abs(a) / a_j, witness)` -> `consume(mpq(1), witness)`.

Traces to the bound_analyzer_on_row.h hunk of FIX.diff, which made the analyzer supply Farkas
coefficients |a_k/a_j| for each premise. In today's code the weighted plumbing exists (and the
proof path), so the verbatim reversal conflicts; the equivalent bug is every premise again carrying
coefficient 1, so bound-propagation hints get wrong coefficients for rows with non-unit coefficients.

Final ./check.sh output:
BUILD OK
FAIL lp_bound_propagation (rc=114)
    ASSERTION VIOLATION
    File: src/src/test/lp/bound_propagation.cpp  Line: 184
    Failed to verify: farkas_coeff_of(imp.m_premises, x_le) == mpq(2)
