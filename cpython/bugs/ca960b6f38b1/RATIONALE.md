# Rationale

Fix hunk reversed: `Python/import.c`, `_PyImport_LazyImportModuleLevelObject`.
The fix changed the filter call args from `{modname, name, fromlist}` to
`{modname, abs_name, fromlist}`. In v3.15.2 the code already used `abs_name`
(with different surrounding variable names), so I changed that single line back to
`{modname, name, fromlist}`. The filter then receives the unresolved name
(e.g. `target` or `''` instead of `pkg.target` / `pkg`) for relative lazy imports.
The docstring/doc hunks are non-functional and were not touched.

Oracle cases failing (4 in test_lazy_import, the filter tests added by the fix):
- test_filter_distinguishes_absolute_and_relative_from_imports
- test_filter_receives_resolved_name_for_relative_package_import
- test_filter_receives_resolved_name_for_parent_relative_import
- test_filter_can_force_eager_only_for_resolved_relative_target
