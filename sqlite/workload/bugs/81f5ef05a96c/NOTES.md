repro.sql is the in6-3.120 case: an IN-subquery on b plus a=0 over index t1(a,b), with TEXT columns holding integers.
Clean shell returns the row `'0'|'10'|'|'`. With the bug, the early OP_IsNull jump skips OP_Affinity, so OP_IfNoHope falsely triggers and the row is missing.
