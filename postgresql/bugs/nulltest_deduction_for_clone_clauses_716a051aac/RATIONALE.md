# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 716a051aaccdef9296c41826034d85c196549146 ("Avoid NullTest deduction for clone clauses"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/initsplan.c

Failing oracle cases:
- `src/test/regress||predicate`
