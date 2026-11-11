# Rationale

One hunk changed: `src/src/muz/rel/doc.cpp`, `doc_manager::project`.

It traces to the `doc.cpp` hunk of FIX.diff at `@@ -279,80 +276,60 @@`. That hunk removed the old shortcut
`if (src.neg().size() == 1) { r->neg().push_back(project(neg[0])); return r; }`. It replaced the shortcut with the
`pick_resolvent` loop. I put the shortcut back in front of that loop.

This reintroduces the same bug. With a single negation that constrains a deleted variable, projecting the negation
directly is unsound. For example, `xxxx \ {xxx0}` with bit 0 deleted should project to the empty set, because
exists b0 . (not b0) is true, so the projected `\ {...}` part should leave nothing. The shortcut instead yields
`xxx \ {xxx}`, which is not equivalent. The fix's new `test_project1` hits exactly this case.

I did not reverse the other hunks. Today's code has no equivalent for the `set_and` equals-check hunk, and the
`copy` and `tbv::set` hunks are not faithful to today's code. When I reverted the `copy`, `set_and` and `tbv::set`
hunks, the doc test still passed, so they are not part of the final diff.

## ./check.sh output
    BUILD OK
    FAIL doc (rc=114)
        xxxx \ {xxx0}
        xxx \ {xxx}
        (or (and true (not (not true))) (and true (not (not false)))) (and true (not true))
        ASSERTION VIOLATION
        File: <z3-src>/src/test/doc.cpp
        Line: 349
        Failed to verify: res == l_false
