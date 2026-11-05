# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2a29b607dbbba47c8e1c97458708e775bfa0e9bb ("Add an output_plugin_libraries GUC to bless trusted output plugins"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/replication/logical/logical.c, src/backend/utils/misc/guc_tables.c, src/bin/pg_dump/dumputils.c, src/bin/pg_upgrade/check.c, src/include/replication/logical.h

Failing oracle cases:
- `src/bin/pg_upgrade|t/003_logical_slots.pl|allowed plugin is not reported`
- `src/bin/pg_upgrade|t/003_logical_slots.pl|check changes are replicated to the sub`
- `src/bin/pg_upgrade|t/003_logical_slots.pl|check the slot exists on new cluster`
- `src/bin/pg_upgrade|t/003_logical_slots.pl|run of pg_upgrade of old cluster`
- `src/bin/pg_upgrade|t/003_logical_slots.pl|run of pg_upgrade of old cluster with slots having unconsumed WAL records status (got 1 vs expected 1)`
- `src/bin/pg_upgrade|t/003_logical_slots.pl|run of pg_upgrade of old cluster with slots having unconsumed WAL records stderr /(?^:)/`
- `src/bin/pg_upgrade|t/003_logical_slots.pl|run of pg_upgrade of old cluster with slots having unconsumed WAL records stdout /(?^:Your installation contains logical replication slots that cannot be upgraded.)/`
- `src/bin/pg_upgrade|t/003_logical_slots.pl|run of pg_upgrade where the old cluster has untrusted output plugins stdout /(?^:Your installation contains logical replication slots with plugins)/`
- `src/bin/pg_upgrade|t/003_logical_slots.pl|run of pg_upgrade where the old cluster has untrusted output plugins stdout /(?^:that are not allowed by the new cluster's output_plugin_libraries)/`
- `src/bin/pg_upgrade|t/003_logical_slots.pl|the previous test failed due to prohibited plugins`
- `src/bin/pg_upgrade|t/003_logical_slots.pl|the previous test failed due to unconsumed WALs`
- `src/bin/pg_upgrade|t/003_logical_slots.pl|the previous test failed due to unconsumed WALs#2`
- `src/test/subscription|t/100_bugs.pl|loading unblessed output plugin fails: stderr`
