Reproducer (repro.sh): turn off defensive mode, set journal_mode=OFF on main and an attached
file database, then commit a transaction that writes to both files.
Clean shell: commits normally, prints `1|2`. Buggy shell: segfaults (exit 139), because OFF
now requires a super-journal and the pager syncs it even though no journal file is open.
