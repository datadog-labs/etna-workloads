#!/bin/bash
"$RUSTC" --crate-type=bin --edition 2021 -Zmir-opt-level=2 -Zdump-mir=fn0 -Zdump-mir-dir=d -o m main.rs 2>&1
echo "exit $?"
grep -h 'fn1(' d/*fn0*.GVN.after.mir | sed 's/-> \[.*//'
