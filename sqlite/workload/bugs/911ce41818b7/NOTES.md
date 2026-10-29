Creates an index with COLLATE nocase, then rewrites its sqlite_master SQL (writable_schema) to use the
unregistered collation "caseless", mimicking a DB reopened without the app collation (collate3-1.7.x).
Clean: "no such collation sequence: caseless" for integrity_check/REINDEX/SELECT.
Buggy: "malformed database schema (i1) - no such collation sequence: caseless (11)" on schema load.
