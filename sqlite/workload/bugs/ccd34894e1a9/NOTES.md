Reproducer for the BTCF_AtLast flag not being cleared in sqlite3BtreeIndexMoveto's
"start on current page" shortcut (injection.patch).

repro.sql builds a 2000-row table and runs `max(c2) OVER (ORDER BY c1 RANGE 1000.0 PRECEDING)`.
The window code keeps its frame in an ephemeral index (default page size, so it must be
large enough to span several pages; the 70-row case in windowE-3.1 only spans pages with
the harness's 1024-byte pages). The stale AtLast flag makes a later seek take a wrong
shortcut, so the window max values differ: the aggregate row printed by the buggy shell
differs from the clean shell.
