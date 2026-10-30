# Rationale

In 9.0.7 `freeClientOrCloseLater()` already exists and is used by
`ACLFreeUserAndKillClients` and `revokeClientAuthentication`. The two sites the
fix converted from `freeClient(c)` still apply, so the bug is restored there
(src/acl.c only):

- `ACLKillPubsubClientsIfNeeded`: `freeClientOrCloseLater(c, 0)` -> `freeClient(c)`
  (reverses the fix's hunk at ~line 1976). A client that removes its own channel
  permissions frees itself while executing the command.
- `ACLLoadFromFile`: `freeClientOrCloseLater(c, 0)` -> `freeClient(c)`
  (reverses the hunk at ~line 2409). `ACL LOAD` by a user removed from the file frees the current client.

Both free `server.current_client`, so `c->conn` becomes NULL and the later reply write asserts in `prepareClientToWrite()`.

## Oracle failures
"Validate a user can remove their own channel permissions" fails: the server
crashes and the client gets "I/O error reading reply" on `ACL SETUSER ... resetchannels`.
"ACL LOAD does not crash server if current user is removed from ACL file" should fail the same way, since the test file aborts at the first crash.
