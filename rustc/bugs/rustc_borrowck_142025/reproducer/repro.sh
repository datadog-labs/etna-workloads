#!/bin/bash
mkdir -p out
"$RUSTC" --edition 2021 --crate-type lib --crate-name ext ext.rs --out-dir out 2>&1
"$RUSTC" --edition 2021 --emit metadata --crate-type bin main.rs --extern ext=out/libext.rlib -L out --out-dir out 2>&1
echo "status=$?"
