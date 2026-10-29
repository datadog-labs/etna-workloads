# Rationale

Fix (CVS 6886) removed `assert( subpage>0 )` from `moveToRoot()` in btree.c, since a corrupt database can make the virtual-root child pointer 0. (The other hunks only add asserts/comments.)

Change: re-added `assert( subpage>0 );` in `moveToRoot()` (src/btree.c) after `subpage = get4byte(&pRoot->aData[pRoot->hdrOffset+8]);`, in the branch for an empty non-leaf page 1. The 3.54.1 code is otherwise the same as the pre-fix shape there (moveToChild handles subpage==0 as corruption).

Oracle: corrupt-5.2 (zeroes the child pointer at offset 108 of page 1) aborts with `Assertion 'subpage>0' failed` instead of returning "database disk image is malformed".
