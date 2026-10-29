Window function with EXCLUDE TIES / EXCLUDE GROUP and no ORDER BY.
Buggy shell builds a KeyInfo from a NULL ORDER BY list and compares peers,
and crashes (SIGSEGV, exit -11) on the EXCLUDE TIES query; the clean shell
prints the rows (1|1, 2|2, 3|3, then NULLs for EXCLUDE GROUP).
