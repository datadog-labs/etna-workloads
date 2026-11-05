# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d9ffc27291fda0041db4f1e9c74ab1148e4b04a8 ("Prevent setting a column as identity if its not-null constraint is invalid"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||constraints`
