repro.sql runs the window1-12.100 query: a window function (lead() OVER (ORDER BY c)) combined with ORDER BY ... LIMIT 1.

- clean: prints `2|B|two` and exits 0.
- buggy: loops forever (the ORDER BY LIMIT optimization is not disabled in the window-function inner loop because `sSort.labelOBLopt = 0` is missing). The shell has to be killed by a timeout.
