# Rationale

File: src/interfaces/ecpg/preproc/pgc.l, `<xcond>{identifier}{space}*";"` rule.

Traces to the fix_impl.patch hunk in the same rule, which changed the active
computation to `parent.active && !saw_active && this_active`. The current code
already has the saw_active field, so I removed the `!saw_active` term. An
`EXEC SQL elif name` after an already-taken branch is therefore activated
whenever its own condition is true, instead of being skipped. Several branches
can then be emitted at once.

Failing oracle case: src/interfaces/ecpg||preproc/define
