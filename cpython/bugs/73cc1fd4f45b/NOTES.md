repro.py re-imports ensurepip with sysconfig.get_config_var patched to return '' and then None, and prints `_WHEEL_PKG_DIR`.
Clean: None in both cases. Buggy: for '' it is the resolved CWD (the injected `is not None` check lets the empty string through, so wheels would be searched in CWD). None behaves the same in both.
