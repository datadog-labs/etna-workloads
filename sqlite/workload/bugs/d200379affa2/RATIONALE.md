# Rationale

## src/alter.c, dropColumnFunc()
Reverses the single implementation hunk of the fix. The fix made the
drop-last-column case start at the previous column's name and tokenize with
getConstraintToken() until a TK_COMMA, so commas inside comments are skipped.
I restored the old code:
- `pCol = renameTokenFind(...aCol[iCol].zCnName)` is hoisted back above the `if`.
- The else branch again scans backwards byte by byte from the dropped column's
  name to the first ',' (`while( ALWAYS(pCol->t.z[0]!=0) && pCol->t.z[0]!=',' ) pCol->t.z--;`).
  It stops at a ',' inside a preceding comment.

getConstraintToken() stays where it is. It is still used elsewhere in the file.

## Oracle failures
`./check.sh` reports altertab3-32.2.1 and 32.2.2. In the 32.2 case the comment
is `-- comment with, comma`, and the backward scan stops at the comma inside the
comment. The ALTER ... DROP COLUMN then yields a wrong schema: the result still
contains the comment and column c. Case 32.1 passes because its comment contains no ',' character, so the backward scan
still lands on the real comma.
