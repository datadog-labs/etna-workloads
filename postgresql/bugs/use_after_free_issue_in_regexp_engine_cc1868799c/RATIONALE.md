# Rationale

File: src/src/backend/regex/regcomp.c (two hunks, both from fix_impl.patch)

1. `parseqatom()`, final "nothing left in the branch" block, where the messy atom is the only thing in the branch.
   Traces to the fix hunk that replaced the copy-t-into-top code with `top->child->sibling = NULL; freesubre(v, top); top = t;`.
   I restored the old code. It frees top->child, copies all of t's fields into top, and calls `freesrnode(v, t)`.
   This reintroduces the bug because t's children are now shared with top, and t is released while it can still be reached.
   Combined with hunk 2, the freed node keeps stale child/sibling pointers.
   The return-value plumbing from the fix stays, since reverting it all would be a far bigger change.

2. `freesrnode()`. Traces to the fix hunk that added `sr->child = sr->sibling = NULL; sr->begin = sr->end = NULL;`.
   I removed those lines. A freed subre now keeps dangling child, sibling, begin and end pointers, which is the use-after-free.

Failing oracle case: src/test/modules/test_regex||test_regex
