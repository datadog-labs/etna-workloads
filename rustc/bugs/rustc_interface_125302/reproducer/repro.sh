#!/bin/bash
RUST_MIN_STACK=banana RUST_BACKTRACE=0 "$RUSTC" --emit metadata --out-dir . main.rs 2>err.txt
echo "status: $?"
grep -c 'panicked' err.txt
grep -E '^(error|note)' err.txt
