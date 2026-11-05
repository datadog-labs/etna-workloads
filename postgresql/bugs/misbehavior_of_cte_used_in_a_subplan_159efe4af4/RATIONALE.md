# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 159efe4af4509741c25d6b95ddd9fda86facce42 ("Fix misbehavior of CTE-used-in-a-subplan during EPQ rechecks."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeCtescan.c

Failing oracle cases:
- `src/test/isolation||eval-plan-qual`
