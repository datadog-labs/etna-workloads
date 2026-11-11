#!/bin/bash
"$RUSTC" --edition 2021 --emit=llvm-ir -C opt-level=0 -o out.ll main.rs 2>&1
echo "status $?"
grep -E '^define .*@take|call .*%f' out.ll | sed 's/ !guid.*//; s/ #[0-9]*//'
