# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 7fcd7ef2a9c372b789f95b40043edffdc611c566 ("Don't use partial unique indexes for unique proofs in the planner"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/indxpath.c, src/backend/optimizer/plan/analyzejoins.c

Failing oracle cases:
- `src/test/regress||join`
