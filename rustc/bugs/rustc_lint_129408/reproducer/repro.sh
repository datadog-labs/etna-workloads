#!/bin/bash
"$RUSTC" --crate-type bin --emit metadata -o out.rmeta main.rs > log.txt 2>&1
echo "status=$?"
grep -c 'panicked' log.txt
grep -E '^(error|help)' log.txt
