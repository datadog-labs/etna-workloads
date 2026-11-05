Changed hunk: src/backend/commands/tablecmds.c, function ATExecValidateConstraint's CHECK-constraint helper (QueryRewrite-era name: QueueCheckConstraintValidation), condition `if (!recursing && !con->connoinherit)` reverted to `if (!recursing)`.
Traces to the single fix_impl.patch hunk (skip find_all_inheritors for NO INHERIT constraints). Without the check, VALIDATE CONSTRAINT on a NO INHERIT check constraint searches children for a constraint that doesn't exist there, raising an error.
(The NOT NULL path at the later site was added after the fix and is left unchanged.)
Failing oracle case: src/test/regress||alter_table
