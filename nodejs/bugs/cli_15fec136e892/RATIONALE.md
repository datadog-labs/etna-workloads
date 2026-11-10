# Rationale

Bug: `--cpu-prof`, `--cpu-prof-name`, `--cpu-prof-interval` and `--cpu-prof-dir` were not allowed in NODE_OPTIONS (missing `kAllowedInEnvvar`), although docs list them as allowed.

Change (src/node_options.cc, one hunk covering four AddOption calls): removed the `kAllowedInEnvvar` argument from the four `--cpu-prof*` options in EnvironmentOptionsParser. This corresponds to the fix's single implementation hunk (re-expressed: `cpu_prof` now uses `BOOL_FIELD(cpu_prof)`).

Failing test: parallel/test-process-env-allowed-flags-are-documented — "The following options are documented as allowed in NODE_OPTIONS ... --cpu-prof-dir --cpu-prof-interval --cpu-prof-name --cpu-prof but are not in process.allowedNodeEnvironmentFlags". Failed on two consecutive runs.
