repro.py compiles `pass` with `_testinternalcapi.compiler_codegen`, then calls `optimize_cfg` with a tuple as `consts`.

- Clean: prints `[None]`, then `TypeError consts must be a list`.
- Buggy: the list type check is missing, so a debug assertion (`PyList_GET_SIZE`) aborts the process (exit status -6).
