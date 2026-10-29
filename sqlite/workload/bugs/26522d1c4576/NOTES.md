repro.sql runs a window with an always-empty frame, `ROWS BETWEEN 2 FOLLOWING AND 1 FOLLOWING`, over a 5-row table.
The clean shell returns NULL for every row. The buggy shell returns two/three/four/NULL/NULL for rows 1–5.
injection.patch removes the check in `sqlite3WindowCodeStep` that handles frames where the start bound passes the end bound.
