Compiles a trivial file with `--lib es2016.intl,es5`.
Clean: accepts the lib name, no diagnostics, exit 0.
Injected: the `es2016.intl` entry is missing from the lib map, so tsc reports an error that the --lib option is unknown (nonzero exit).
