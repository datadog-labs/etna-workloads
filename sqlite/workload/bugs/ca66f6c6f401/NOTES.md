repro.sql: in a 1024-byte-page auto-vacuum database, REPLACE a row holding a 104-byte blob with
one holding a 1117-byte blob. The new cell (spilling to overflow) has the same size as the old
in-page cell. The buggy build overwrites the cell in place, skipping insertCell() and so the
PTRMAP_OVERFLOW1 entry. `PRAGMA integrity_check` then reports "Bad ptr map entry key=4 expected=(3,3) got=(3,0)"
on the buggy shell; the clean shell prints "ok".
