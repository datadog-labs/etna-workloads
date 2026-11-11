#!/bin/bash
export RUSTC_BOOTSTRAP=1
rm -rf inc out; mkdir out
"$RUSTC" --edition 2021 --crate-type lib -C incremental=inc --out-dir out main.rs 2>&1; echo "first: $?"
o=$("$RUSTC" --edition 2021 --crate-type lib -C incremental=inc --out-dir out -Zunstable-options -Zincremental-verify-ich main.rs 2>&1); s=$?
echo "$o" | head -2 | cut -c1-120; echo "second: $s"
