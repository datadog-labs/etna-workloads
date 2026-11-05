# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f4290f20dd4d6f75e01fbb87304c3b8f31d1cfea ("Fix assertion failure in parallel vacuum with minimal maintenance_work_mem setting."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/heap/vacuumlazy.c

Failing oracle cases:
- `src/test/regress||vacuum`
