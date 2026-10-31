Adds `--no-foo` with `argparse.BooleanOptionalAction`. Clean raises
`ValueError("invalid option name '--no-foo' for BooleanOptionalAction")`; buggy
accepts it silently and prints `no error`.
