# update_projection_maps_projectionpullup_restructures_4d1ef6f17f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 4d1ef6f17f77e37862e577b596b91ba346cad016 ("update projection_maps when ProjectionPullup restructures the plan"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/projection_pullup.test
