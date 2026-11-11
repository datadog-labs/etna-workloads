#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib transitive_dep.rs --out-dir out 2>&1
"$RUSTC" --edition 2021 --crate-type lib direct_dep.rs --out-dir out -L out --extern transitive_dep=out/libtransitive_dep.rlib 2>&1
"$RUSTC" --edition 2021 main.rs --out-dir out -L out --extern direct_dep=out/libdirect_dep.rlib --extern transitive_dep=out/libtransitive_dep.rlib --error-format=human --color never 2>&1 | sed 's/^ *--> .*/-->/'
