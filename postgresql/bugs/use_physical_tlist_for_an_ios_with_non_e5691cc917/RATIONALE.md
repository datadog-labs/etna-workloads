# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e5691cc9170bcd6c684715c2755d919c5a16fea2 ("Don't use_physical_tlist for an IOS with non-returnable columns."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/createplan.c

Failing oracle cases:
- `src/test/regress||gist`
