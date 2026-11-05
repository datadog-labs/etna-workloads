Changed: src/backend/executor/execGrouping.c, BuildTupleHashTableExt(). Traces to the fix hunk that replaced `&TTSOpsMinimalTuple` with `inputOps` in the ExecBuildHash32FromAttrs() call. The bug is back because the hash ExprState again assumes input slots are MinimalTuple slots, whatever the callers actually pass (virtual slots from nodeAgg and nodeSubplan). The hash expression then reads the wrong slot type. The inputOps parameter is kept, but it is ignored.

Failing oracle case: src/test/regress||with
