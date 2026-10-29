repro.sql: the null-10.1 case. A table with a DESC primary key has one row (0). The query `WHERE c0 > NULL` should return no rows.
The buggy shell (the optimization is re-added) emits the OP_IsNull range-start check for reversed scans too, so the clean and buggy shells differ in output. The clean shell returns nothing.
