# Rationale

## Changed hunk
- File: `src/backend/replication/logical/tablesync.c`, function `make_copy_attnamelist()`.
- Traces to the `tablesync.c` hunk of fix.patch (`make_copy_attnamelist`).
- The fix builds the COPY column list from the remote relation's columns in remote order (`rel->remoterel.attnames[i]`). That matches the order the publisher sends, because the initial COPY query lists `lrel.attnames`.
- I restored the old code. It iterates over the local tuple descriptor in local column order, skips dropped and remote-missing columns, and maps each one through `rel->attrmap->attnums[i]`. The `attrmap` is now a struct, so it is `attnums[i]` here. The COPY column list is then in local order while the data arrives in remote order. With different column orders, values land in the wrong columns, or the COPY fails with a type mismatch.
- The `relation.c` hunk (skipping dropped columns in `logicalrep_rel_open`) is not reverted. Current code already sets dropped columns to -1 explicitly, so removing that skip would change nothing.

## Failing oracle cases
All 38 cases in `t/001_rep_changes.pl` fail with status "missing". The script aborts early, during the initial table sync with different column order.
