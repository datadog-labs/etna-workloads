#!/bin/bash
"$RUSTC" --edition 2021 --crate-type=lib --crate-name dep dep.rs -o libdep.rlib
"$RUSTC" --edition 2021 --crate-type=lib main.rs --extern dep=libdep.rlib 2>&1
echo "exit: $?"
