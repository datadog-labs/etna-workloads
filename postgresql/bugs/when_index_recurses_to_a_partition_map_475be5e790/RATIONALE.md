# Rationale

The original fix added code in DefineIndex's partition recursion to run map_variable_attnos over expression index params (IndexElem->expr). In REL_18_6 that recursion builds the child IndexStmt with generateClonedIndexStmt(), which now does the expression Var remapping.

## Changed hunk
- File: src/backend/parser/parse_utilcmd.c, function generateClonedIndexStmt (the "Expressional index" branch).
- Traces to the fix.patch hunk in indexcmds.c DefineIndex that mapped `ielem->expr` with map_variable_attnos.
- Change: removed the map_variable_attnos call on `indexkey`. Index expressions therefore keep the parent's column numbers when the index recurses to a partition whose columns are numbered differently. The result is wrong or invalid child index expressions.

## Failing oracle cases
- src/test/regress||indexing
