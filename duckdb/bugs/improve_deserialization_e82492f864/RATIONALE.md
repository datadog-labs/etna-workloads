# improve_deserialization_e82492f864

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e82492f86416da78387a53d6dd44c8b1c038d846 ("improve deserialization"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/optimizer/function_invocation_serialization.cpp::Plans written for older versions select overloads with required keyword-only parameters
