# duplicated_value_argument_optimizer_generated_a48fb49220

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a48fb49220fb87daa13ccaeb15eaa0e4a82c3d55 ("Fix duplicated value argument in optimizer-generated constant_or_null()"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/constant_or_null_value_arg.test
