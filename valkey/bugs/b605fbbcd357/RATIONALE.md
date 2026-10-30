# Rationale

## src/acl.c, ACLLoadFromFile
Reverses the fix hunk that added `clientSetUser(c, DefaultUser, 0);` before
`freeClientOrCloseLater(c, 0)` for clients whose user was deleted/changed by
ACL LOAD. In 9.0.7 the surrounding code is unchanged, so deleting that single
line restores the pre-fix state: a protected/deferred client keeps `c->user`
pointing at an old user that is freed by `raxFreeWithCallback(old_users, ...)`.

The debug.c hunk (DEBUG PROTECT-CLIENT) is test support already present in 9.0.7; not touched.

## Oracle
"ACL LOAD does not leave dangling user pointer on protected clients" fails:
`CLIENT LIST` dereferences the freed `c->user->name` and the server crashes
(`r CLIENT LIST` errors out), matching the UAF the fix guards against.
