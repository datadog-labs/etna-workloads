Compiles a trivial file with `--lib es2023.intl,es2015`.
Clean: the lib name is accepted (no diagnostics, exit=0).
Injected: `es2023.intl` was removed from the lib list, so tsc reports error TS6046 (invalid --lib argument), exit=1.
