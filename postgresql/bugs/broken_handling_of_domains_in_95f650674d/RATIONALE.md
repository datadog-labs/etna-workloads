# Rationale

Hunk: src/backend/commands/tablecmds.c, ATExecAddColumn (missing-value eligibility condition).
Traces to the fix_impl.patch hunk that added the condition
`!has_domain_constraints && !contain_volatile_functions((Node *) defval)`, and the comment that
defaults must not be volatile. In the current code the condition is
`relkind == RELATION && !colDef->generated && !has_domain_constraints && !contain_volatile_functions(defval)`.
I removed the `contain_volatile_functions(defval)` test. Domain-supplied volatile defaults (e.g.
domain2 DEFAULT random()) now get evaluated once and stored as attmissingval instead of forcing
a table rewrite, so all existing rows share one value. This is the broken domain handling in the
atthasmissing logic.

Failing oracle case: src/test/regress||fast_default
