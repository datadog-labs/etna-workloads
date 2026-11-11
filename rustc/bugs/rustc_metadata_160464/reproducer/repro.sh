#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --crate-name transitive_dep transitive.rs --out-dir out 2>&1
"$RUSTC" --edition 2021 --crate-type lib --crate-name direct_dep_with_multiple_reexports direct.rs --out-dir out --extern transitive_dep=out/libtransitive_dep.rlib 2>&1
"$RUSTC" --edition 2021 --crate-type bin main.rs -o out/main -L out --extern transitive_dep=out/libtransitive_dep.rlib --extern direct_dep_with_multiple_reexports=out/libdirect_dep_with_multiple_reexports.rlib --error-format short 2>&1
echo "status $?"
