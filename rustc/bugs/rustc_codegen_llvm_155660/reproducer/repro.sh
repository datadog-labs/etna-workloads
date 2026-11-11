#!/bin/bash
T=sparc64-unknown-linux-gnu
"$RUSTC" --edition 2021 --target $T --crate-type rlib --crate-name minicore -Copt-level=3 minicore.rs --emit metadata,link -o libminicore.rlib 2>&1 | grep -c error
"$RUSTC" --edition 2021 --target $T -Copt-level=3 -Awarnings --emit asm -o out.s --extern minicore=libminicore.rlib main.rs 2>&1
echo "status $?"
grep -A8 '^read_i32:' out.s | grep -E 'ldsw|ldx|add'
