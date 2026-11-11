# Rationale
Three hunks, each undoing part of the implementation in FIX.diff:
1. src/ast/fpa_decl_plugin.cpp, mk_float_sort: removed the `sbits > MPF_MAX_SBITS` rejection (FIX hunk 1). Oversized significands are accepted again and silently truncated by mpf's 16-bit field. This is what makes test_significand_out_of_range fail.
2. src/ast/rewriter/fpa_rewriter.cpp, mk_to_fp: removed the `sbits > 0xffff` BR_FAILED guard (FIX hunk 2), so numerals can be built with a truncated sort.
3. fpa_rewriter.cpp, mk_is_inf_of_int: removed the large-sbits exact-threshold branch and the half_ulp_exp range check, and restored the signed `(int)max_exp - (int)sbits + 1` ulp computation (FIX hunk for mk_is_inf_of_int). This brings back the unsigned-to-signed narrowing of sbits.
The null-check in mk_is_normal was left as is (harmless).
Final ./check.sh output:
BUILD OK
FAIL fpa (rc=114)  ASSERTION VIOLATION test/fpa.cpp line 77: response.find("maximum number of significand bits") != npos
