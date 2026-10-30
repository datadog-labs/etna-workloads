Reproducer: creates a stream group, subscribes to `__keyevent@0__:xgroup-createconsumer`, then XREADGROUP creates consumer alice and XGROUP CREATECONSUMER creates bob.
With the bug, the implicit consumer creation in XREADGROUP (also XCLAIM/XAUTOCLAIM) neither fires the xgroup-createconsumer notification nor bumps the dirty counter:
clean shows rdb_changes_since_last_save:3 and 2 events received; buggy shows 2 and 1.
