# GH-126920 reintroduced

Fix hunk: `_init_posix` changed `vars.update(build_time_vars)` to
`vars.update(build_time_vars | vars)` so Makefile values don't overwrite keys
already set (notably `prefix`/`exec_prefix`).

In v3.15.2 the `|vars` guard still exists in `_init_posix`, but
`_init_config_vars` sets `prefix`/`exec_prefix` *after* `_init_posix`, so the
guard is no longer what protects them. Changes in `Lib/sysconfig/__init__.py`:

1. `_init_posix`: back to `vars.update(_get_sysconfigdata())` (reverses the fix hunk).
2. `_init_config_vars`: `prefix`/`exec_prefix` are seeded into `_CONFIG_VARS`
   before `_init_posix` (as in the pre-fix flow, where they were already set
   and then clobbered), and the later unconditional assignment is removed
   (re-applied only in the cross-compile branch, which has its own values).
   So the Makefile's `prefix`/`exec_prefix` overwrite sys.prefix/sys.exec_prefix.

Oracle failures: `test_sysconfig_config_vars_no_prefix_cache` (get_config_vars()['prefix']
is '/usr/local' instead of sys.prefix) and a second TestSysConfig case
(see check.sh output). `test_makefile_overwrites_config_vars` was skipped here / not among failures.
