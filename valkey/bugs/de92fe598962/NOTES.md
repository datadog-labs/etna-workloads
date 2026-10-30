repro.sh starts a server, sets an ACL user with the `skip-sanitize-payload` flag, and prints `ACL LIST` / `ACL GETUSER`.
Clean 9.0.7 accepts the deprecated flag as a no-op: it never appears in the output.
The buggy build shows `sanitize-payload` on every user and `skip-sanitize-payload` on u1.
