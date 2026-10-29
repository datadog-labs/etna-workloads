Reproducer: `repro.sh` sets TZ=UTC-5 (a fixed +5h local zone; the shell's `.testctrl localtime_fault` can't select the test's alternate localtime_r) and runs
`SELECT datetime('2000-10-29 12:00:00Z','localtime','localtime')`.
Clean: `2000-10-29 17:00:00` (second 'localtime' is a no-op). Buggy: `2000-10-29 22:00:00` (offset applied twice).
This mirrors date-6.32.
