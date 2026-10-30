# Rationale

Fix hunk reversed: the `reset` branch of `ACLSetUser` in `src/acl.c` (the
`if (server.acl_pubsub_default & USER_FLAG_ALLCHANNELS) ACLSetUser(u,"allchannels")`
added after `resetchannels`). In 9.0.7 the code is the same apart from naming:
`SELECTOR_FLAG_ALLCHANNELS`, and the call is spelled `ACLSetUser(u, "allchannels", -1)`.
I removed those two lines, so `reset` leaves the user with no channel access
regardless of `acl-pubsub-default`.

The other hunks only rename `acl_pubusub_default` to `acl_pubsub_default`. They
are cosmetic and already applied in 9.0.7. `ACLCreateUser` and the selector
creation path already apply the default, so only `reset` is affected.

Oracle failures: "default: with config acl-pubsub-default allchannels after
reset, can access any channels" fails with NOPERM on `SUBSCRIBE foo` after
`ACL setuser default reset ...`. The check.sh output I looked at showed only
this failure. I did not look for other failing cases, such as the
include-file and config-file loading cases.
