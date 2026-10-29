# Rationale

Fix hunk (src/vdbeapi.c, sqlite3_step): the fix replaced the unconditional
`v->doingRerun = 1` after a schema-triggered reprepare with
`v->doingRerun = savedPc>=0`, so that a statement marked expired before it ever
started (pc<0) still fires the trace callback on its re-run.

In 3.54.1 `doingRerun` became `v->minWriteFileFormat = 254` (tag-20220401a),
a flag that makes OP_Init/OP_Trace skip SQLITE_TRACE_STMT. It is set only
`if( savedPc>=0 )`. I removed that condition (and the now-unused `savedPc`
local), restoring the pre-fix unconditional behaviour: the trace is
suppressed on the rerun even if it never ran before.

Failing oracle case: test/trace.test trace-1.7 (the trace callback is never
invoked for `SELECT y FROM t1b WHERE x GLOB $xyzzy`, since the statement is
expired by the schema change before first step). trace-1.6 still passes.
