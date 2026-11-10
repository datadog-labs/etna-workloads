# Adapted injection for Fix #128930: Print documentation of CLI options missing their arg

Fix: https://github.com/rust-lang/rust/commit/6360287fd91c5d02597b45ef65c34388af348638

# Rationale
compiler/rustc_driver_impl/src/lib.rs, `handle_options`: removed the `getopts::Fail::ArgumentMissing(ref opt) => {...}` match arm that prints per-option usage. This re-expresses the fix hunk `@@ -1221,17 +1221,30 @@ pub fn handle_options` which added that arm (`getopts::Fail::ArgumentMissing(ref opt) => { optgroups.iter().find(...)... usage_with_format ...`). Now `--print` with no arg falls to `_ => None` and prints only "Argument to option 'print' missing".
The config.rs hunk (`name` made `pub`) is visibility only; already pub in 1.99.1, not changed.
