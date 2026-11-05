# Rationale

File: src/src/backend/regex/regcomp.c, function parseqatom (backref branch).
Traces to the fix.patch hunk in parseqatom that adds, after dupnfa() copies the
subexpression NFA into the backref atom, `removeconstraints(v->nfa, atom->begin, atom->end); NOERR();`.
I removed that call (the NOERRN() form in current code), so the copied NFA keeps its
constraints (lookahead, ^, $, lookbehind, LACON). A back-reference then enforces constraints
from the referenced subexpression, which is the original wrong semantics.
The removeconstraints/removetraverse helpers are left in place, now unused.

Failing oracle case: src/test/modules/test_regex||test_regex
