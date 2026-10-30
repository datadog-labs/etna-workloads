Starts a primary and a replica (replica uses `--aclfile`), waits for the link to come up, then runs `ACL SETUSER`, `ACL SAVE` and `ACL LOAD` on the replica.
Clean: all commands reply OK and the replica still answers PING.
Buggy: `ACL LOAD` segfaults the replica, because ACLLoadFromFile dereferences the NULL `c->user` of the primary client. The CLI prints "Server closed the connection", and later connections are refused.
