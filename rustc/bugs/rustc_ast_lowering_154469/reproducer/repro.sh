#!/bin/bash
rm -rf inc
"$RUSTC" --crate-type lib --edition 2021 -C incremental=inc -Z incremental-verify-ich --emit metadata --out-dir out main.rs 2>&1 | grep -E "^error" | sed 's/:[0-9]*:[0-9]*:.*//' 
echo "status: ${PIPESTATUS[0]}"
