Reproducer: sets `acl-pubsub-default allchannels`, then runs `ACL SETUSER <user> reset on nopass ~* +@all`
and checks `ACL GETUSER` channels and `PUBLISH`.
Clean: reset users keep `&*` and PUBLISH returns 0. Buggy: channels are empty and PUBLISH gives NOPERM
(the `reset` rule no longer re-applies allchannels).
