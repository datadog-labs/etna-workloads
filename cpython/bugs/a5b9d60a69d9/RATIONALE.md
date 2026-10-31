# gh-145059 reintroduced

Fix: `register_lazy_on_parent` (dotless branch) now records top-level lazy
modules that have no submodules; before, they were missing from `sys.lazy_modules`.

In v3.15.2 `sys.lazy_modules` is a set filled by `lazy_modules_add` (Python/import.c),
so the same code path was changed: `lazy_modules_add` again skips names without a
dot (top-level modules with no submodules), so `lazy import json` is not tracked.

Oracle failing: `test_lazy_module_without_children_is_tracked` and one more
test asserting a dotless lazy module (`custom_spec`) is in `sys.lazy_modules`.
