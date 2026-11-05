# Rationale

Reverse of the fix, adapted to current code:

- src/backend/commands/user.c, CreateRole() and AlterRole(): removed the empty-password check (and the NOTICE "empty string is not a valid password, clearing password"); the password is always encrypted and stored. Traces to the two user.c hunks of fix.patch. An empty password is stored as a real hashed password again.
- src/backend/libpq/auth.c, recv_password_packet(): removed the `buf.len == 1` "empty password returned by client" error. Traces to the auth.c recv_password_packet hunk.
- The per-method PAM/LDAP/RADIUS checks and the crypt.c check were removed by the fix itself. They were not re-added, because the user.c and auth.c reversals are enough to bring the bug back.

Failing oracle case: src/test/regress||password
