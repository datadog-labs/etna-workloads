# Rationale

File: src/backend/commands/tablecmds.c, function ATExecDropColumn (traces to the ATExecDropColumn hunks of fix_impl.patch).

- The end of the function again calls performDeletion() on each column right away, in every recursive call. The fix instead collected the addresses in `addrs` and dropped them all together with performMultipleDeletions() once the recursion finished.
- I removed the `addrs = new_object_addresses()` initialization on the first call.
- The `addrs` parameter is still in the signature but is no longer used.

Dropping the parent column first, or each child column on its own, brings back the dependency-handling bug for partitioned tables. Dependencies such as partitioned indexes that span the hierarchy are handled per relation instead of for the whole set at once.

Failing oracle case: src/test/regress||indexing
