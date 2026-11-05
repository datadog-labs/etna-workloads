# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f4857082bc16f36a5cdc6f8328cdc8071bb1715e ("Fix planner failure with extended statistics on partitioned tables."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/selfuncs.c

Failing oracle cases:
- `src/test/regress||stats_ext`
