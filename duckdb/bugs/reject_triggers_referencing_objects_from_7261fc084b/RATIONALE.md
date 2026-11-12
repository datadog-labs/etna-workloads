# reject_triggers_referencing_objects_from_7261fc084b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7261fc084b23b6f432fe84b3790660018927b58c ("Reject triggers referencing objects from a different catalog at CREATE time"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/trigger/trigger_dependency.test
