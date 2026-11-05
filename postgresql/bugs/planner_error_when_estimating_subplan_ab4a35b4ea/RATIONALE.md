# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ab4a35b4ea9d2290b1ee5ec25f65df4c739077cb ("Fix planner error when estimating SubPlan cost"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/costsize.c

Failing oracle cases:
- `src/test/regress||subselect`
