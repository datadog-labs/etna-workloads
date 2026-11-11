# Rationale

Changed hunk: `src/src/math/lp/lp_utils.h`, `try_get_value`. It traces to the lp_utils.h hunk of FIX.diff.

Today's code already uses `std::optional`, so the fix cannot be reversed verbatim. I re-expressed the pre-fix behaviour instead.
Before the fix, `try_get_value` reported only whether the key was found. It did not hand the stored value back through its return value.
In the new signature, a hit now returns a default-constructed `B()` instead of `it->second`. The lookup succeeds but the value is lost.

The `optional` unit now fails at the assertion `*result1 == "one"`.

The `dl_query` unit still passes. Its problem file path is a hard-coded Windows path that does not exist here, so the test returns early. It never reaches the `try_get_size` code.
I tried changes to the `try_get_size` call sites, and `dl_query` still passed each time. I reverted all of them.

## ./check.sh output
BUILD OK
PASS dl_query
FAIL optional (rc=114)
    ASSERTION VIOLATION
    File: .../src/test/optional.cpp
    Line: 81
    Failed to verify: *result1 == "one"
