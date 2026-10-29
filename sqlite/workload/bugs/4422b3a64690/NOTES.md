repro.sql is test in4-12.1 (ticket 6dcbfd11cf666e21) run as plain SQL. It builds t1 with two indexes and fakes sqlite_stat1 so the planner uses a multi-index OR plan with IN on index t1bca.
The OR plan reopens the same index cursor via OP_ReopenIdx. Without the fix the cursor isn't cleared, which leaves state that confuses OP_SeekScan.
Clean shell prints `56|1119|1115`. Buggy shell prints nothing (a missing row).
