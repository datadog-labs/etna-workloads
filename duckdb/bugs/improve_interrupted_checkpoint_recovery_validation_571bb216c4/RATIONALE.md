# improve_interrupted_checkpoint_recovery_validation_571bb216c4

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 571bb216c4c170008eea9bbbf6512915737e9547 ("Improve interrupted checkpoint recovery validation"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/sql/storage/wal_checkpoint_marker.cpp::Reject multiple checkpoint markers before changing WAL files
