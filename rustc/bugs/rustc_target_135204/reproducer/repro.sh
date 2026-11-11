#!/bin/bash
export RUST_BACKTRACE=0
"$RUSTC" --edition 2021 --crate-type=lib --emit=llvm-ir -O -o out.ll main.rs >log.txt 2>&1
echo "exit: $?"
grep -E 'Tried to make|unexpectedly panicked' log.txt
grep -E 'define.*@f\(' out.ll
