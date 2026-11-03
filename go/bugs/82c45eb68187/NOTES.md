repro.sh compiles a package with `-gcflags='-m -l'` containing a method value `t{}.f` of a huge type (`[20000]*int`, 160KB).
Clean: reports "t{}.f escapes to heap" and "moved to heap: i" (too large for stack).
Buggy: the escape analysis size check for OMETHVALUE is missing, so those diagnostics are absent.
