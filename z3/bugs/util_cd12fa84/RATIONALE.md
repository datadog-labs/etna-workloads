# Rationale
FIX.diff adds fixed_bit_vector.cpp (whole file; cannot be reversed verbatim). Changed hunk: in
fixed_bit_vector_manager::last_word (src/src/util/fixed_bit_vector.cpp) the final word is no longer
masked with m_mask, so unused high bits of the last word leak into equals()/contains(). This is the
masking logic from the fix's `last_word`/`equals` hunks. The fixed_bit_vector test (fill1 vs set_neg(fill0),
non-multiple-of-32 sizes) now fails at its equals assertion.

check.sh output:
FAIL fixed_bit_vector (rc=114)
