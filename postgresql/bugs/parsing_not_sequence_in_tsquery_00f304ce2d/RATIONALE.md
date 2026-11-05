# Rationale
File: src/backend/utils/adt/tsquery.c, function cleanOpStack().
Traces to the single fix_impl.patch hunk. I removed the special case that made NOT right associative, so the loop break test is again `opPriority > OP_PRIORITY(top)` for every operator. Parsing a NOT sequence such as `!!a` then pops the earlier NOT off the stack and produces the wrong tree.

Failing oracle case: src/test/regress||tstypes
