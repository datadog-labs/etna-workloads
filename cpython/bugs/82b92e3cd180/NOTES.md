Reproducer: `socket.sendmsg()` with an ancillary-data list whose first item's `__index__` clears the list while it is being parsed.
Clean: the list is copied to a tuple first, so `sendmsg` raises OSError (prints "OSError").
Buggy: it uses `PySequence_Fast`, which borrows the list, so the item is read after the list is cleared. The buggy interpreter segfaults (exit -11).
