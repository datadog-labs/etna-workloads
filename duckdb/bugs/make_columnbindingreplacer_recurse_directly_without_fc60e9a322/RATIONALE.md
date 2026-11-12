# make_columnbindingreplacer_recurse_directly_without_fc60e9a322

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit fc60e9a322481ff46afe8fced32fb7afed49284f ("Make ColumnBindingReplacer recurse directly without resolving projection maps"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/projection_pullup_out_of_bounds.test_slow
- test/optimizer/projection_pullup_projection_map.test
