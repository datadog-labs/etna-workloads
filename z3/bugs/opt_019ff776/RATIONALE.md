# Rationale
Single hunk in src/src/util/sorting_network.h (psort_nw::eq, sorted_at_most branch). Traces to the FIX.diff hunk in src/util/sorting_network.h
`-return out[k-1]; // & ~out[m] TBD` / `+return ctx.mk_min(out[k-1], ctx.mk_not(out[k]));`.
Today's code has the fixed form (k==0 special case plus mk_min(out[k-1], mk_not(out[k]))); I reverted it to `return out[k-1];`,
so "exactly k" only encodes "at least k", the original sorting network bug.

check.sh result:
PASS hilbert_basis
FAIL sorting_network (rc=114)
