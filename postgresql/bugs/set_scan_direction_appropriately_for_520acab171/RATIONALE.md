# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 520acab171244b55d816c70b9a89280b09937925 ("Set scan direction appropriately for SubPlans (bug #15336)"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/executor/nodeSubplan.c

Failing oracle cases:
- `src/test/regress||subselect`
