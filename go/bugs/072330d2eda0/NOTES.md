Reproducer (`repro.sh`): `*PoolConn` embeds interface `Conn`, so the compiler generates a
tail-call wrapper `(*PoolConn).Hello` -> `Conn.Hello`. Without the fix, that tail call never
marks the interface method as used, so the linker drops `CustomConn.Hello` (the value is
only converted to `Conn` dynamically via a type assertion, so no static itab keeps it).

- clean: prints `called`, exit 0.
- buggy: `fatal error: unreachable method called. linker bug?`, exit 2.

The script uses a private GOCACHE because both toolchains report the same version and
would otherwise share cached compile output.
