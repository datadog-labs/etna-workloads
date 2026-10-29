# Rationale

Fix hunk (src/resolve.c, resolveCompoundOrderBy): in the ALTER TABLE RENAME
case, after a resolved ORDER BY term was marked done, the original code did
`break` (leaving the loop over the ORDER BY terms and skipping the rest); the fix
changed it to `continue`.

In 3.54.1 the loop was restructured, so the `break`/`continue` line no longer
exists: the rename branch now just falls through to `pItem->fg.done = 1;` and the
loop continues. The change in `tree/src/resolve.c` restores the early exit:
`if( IN_RENAME_OBJECT ) break;` right after `pItem->fg.done = 1;`. This is
equivalent to the old `done=1; break;` under `IN_RENAME_OBJECT && iCol>0`
(we are inside `if( iCol>0 )` there).

Effect: with a compound SELECT such as `... UNION ... ORDER BY b,c` inside a
trigger, only the first ORDER BY term is resolved during rename; the later terms
stay unresolved (and are not renamed), and the check at the end of the function
reports "2nd ORDER BY term does not match any column in the result set".

Failing oracle cases: altertab2-7.3 (both instances, the table rename and the
column rename): "error in trigger r1: 2nd ORDER BY term does not match any
column in the result set", followed by a consequent "no such table: xyzzy".
