Changes (src/src/util/distribution.h), both from the util/distribution.h hunks of FIX.diff:

1. `choose(unsigned sum)`: FIX.diff hunk "@@ -32,10 +34,12" made it return the index into m_elems (idx counter) rather than the element id `j`. Reverted to `return j;`. The callers index m_elems with the result, so ids are used as indices (out of range).
2. `iterator::operator++`: FIX.diff hunk "@@ -88,8 +91,9" swapped the chosen element with `m_elems[m_sz]` (the end of the live range). Reverted to swapping with `m_elems[size()-1]`, so already-visited elements are not kept out of the remaining range.

Not reintroduced: the missing `return *this;` and next_index restyle (no behavior effect / UB-only).

check.sh output:
BUILD OK
FAIL distribution (rc=110)
    ASSERTION VIOLATION  File: src/src/util/vector.h Line: 364  idx < size()
