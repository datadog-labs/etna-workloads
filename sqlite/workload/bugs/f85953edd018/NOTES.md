repro.sh creates a db file, prints the header change counter (bytes 24-27), runs VACUUM, and prints it again.
Clean: counter goes 2 -> 3 (VACUUM increments it). Buggy: 4 -> 2 (the counter is computed from the page content
instead of dbFileVers, so the VACUUM'd value is wrong and doesn't increase).
