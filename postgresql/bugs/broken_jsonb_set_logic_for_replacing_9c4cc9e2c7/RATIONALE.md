# Rationale
File: src/backend/utils/adt/jsonfuncs.c (fix.patch hunks map 1:1)
- Flag defines: dropped JB_PATH_REPLACE, restored JB_PATH_NOOP=0 and old values.
- jsonb_set() (today in the jsonb_set path at the setPath call): replace uses JB_PATH_NOOP instead of JB_PATH_REPLACE.
- setPathArray(): the condition that pushes newval no longer includes JB_PATH_REPLACE, so replacing an array element drops it instead of substituting newval.

Failing oracle case: src/test/regress||jsonb
