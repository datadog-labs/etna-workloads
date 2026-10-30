Starts a server with `--rename-command set myset`, then checks `COMMAND INFO myset` name,
and `ACL SETUSER ... -set` / `ACL GETUSER`.
Clean: the command's fullname stays `set` (info reports `set`, `-set` is accepted and shown in ACL GETUSER).
Buggy: rename overwrites fullname (info reports `myset`, `-set` rejected as unknown command).
