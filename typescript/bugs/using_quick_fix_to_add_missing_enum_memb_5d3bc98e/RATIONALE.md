Hunk 1 (fix.diff, fixAddMissingMember.ts import): removed `lastOrUndefined` import, as the fix added it.
Hunk 2 (addEnumMemberDeclaration): restored pre-fix code that replaces the whole enum declaration via changes.replaceNode with updateEnumDeclaration(concatenate(members, enumMember)) instead of insertNodeInListAfter / insertMemberAtStart. This reprints the enum, producing extra/missing newlines and trailing comma/brace formatting errors.
textChanges.ts hunks not reverted: they only widen types / affect the list insert path, which is no longer used by this fix.

SUMMARY: 6/90 oracle cases failing (2 fix-added).
