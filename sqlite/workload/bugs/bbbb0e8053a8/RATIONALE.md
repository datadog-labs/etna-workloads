# Rationale

## Changed: src/vdbe.c, OP_Delete update-hook call
The fix added `&& pC->isTable` to the OP_Delete update-hook condition so the
hook is not invoked for WITHOUT ROWID tables. In 3.54.1 the equivalent guard
is `HasRowid(pTab)` in `if( db->xUpdateCallback && ALWAYS(pTab!=0) && HasRowid(pTab) )`.
I removed `HasRowid(pTab)`, restoring the pre-fix behaviour: the hook fires on
DELETE from a WITHOUT ROWID table (with a bogus rowid, `movetoTarget`).

The other fix hunks (resolve.c comment-only, manifest, tests) need no reversal.

## Oracle failure
`test/hook.test` case `hook-4.1.2w` fails: the update hook reports DELETE
callbacks for t1w, where an empty list is expected.
