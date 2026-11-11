#!/bin/bash
"$RUSTC" --edition 2021 -O -Zmir-opt-level=2 --crate-type bin main.rs -o main 2>&1 | grep -E "internal compiler error|incompatible types|left-hand|right-hand" | sed 's/(after pass.*//;s/DefId.*//'
echo "rustc status: ${PIPESTATUS[0]}"
[ -x main ] && ./main
