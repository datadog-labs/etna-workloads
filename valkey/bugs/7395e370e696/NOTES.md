Adds 1-1..1-3 to a stream, deletes 1-2 and 1-3 (max-deleted-entry-id = 1-3), then runs XSETID x 1-2.
Clean: returns an error "smaller than current max_deleted_entry_id". Buggy: returns OK, since the check was removed.
