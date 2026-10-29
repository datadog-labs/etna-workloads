Reproducer is the gencol1-3.100/3.110 case: a table with a virtual generated column
that has a FOREIGN KEY reference, followed by an UPDATE. With the bug, the pre-UPDATE
(old) register content for columns after the virtual column is mis-indexed, so the
FK check uses wrong values. Clean shell reports "FOREIGN KEY constraint failed" for the
last UPDATE; the buggy shell gives a different result (see ./check.sh).
