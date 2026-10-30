# Rationale

## Changed hunk
`tree/src/t_stream.c`, `xsetidCommand`: removed the check, placed right after the
key lookup and type check, that rejects an ID smaller than `s->max_deleted_entry_id`
("The ID specified in XSETID is smaller than current max_deleted_entry_id").

This reverses the single implementation hunk of the fix. The code had only been
reformatted since (spacing after commas), so the removal is exactly the pre-fix state.
The earlier check against the *provided* MAXDELETEDID is a separate pre-existing check and is untouched.

## Oracle failure
`XSETID cannot set smaller ID than current MAXDELETEDID` fails: `XSETID x 1-2` with
max-deleted-entry-id 1-3 returns `OK` instead of `ERR *smaller*`.
