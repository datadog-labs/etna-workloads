Reproducer: 3-node cluster (source A, import target B, B's replica C, cluster-databases 16).
Slot 16383 is migrated A->B with DEBUG SLOTMIGRATION PREVENT-PAUSE so the import stays open; the
proxied stream selects db 2 (snapshot + incremental writes) while B also does its own writes in
db 1 and db 0. Finally DBSIZE per db is compared between B and replica C.

Clean: primary and replica match (db0 1/1, db1 2/2, db2 5/5).
Buggy: replicas' selected db is not tracked across the proxied import stream, so B's writes land
in the wrong db on C (db0 primary=1 replica=2, db1 primary=2 replica=1).
