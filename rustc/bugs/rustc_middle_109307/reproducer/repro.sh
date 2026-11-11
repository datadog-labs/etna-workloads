#!/bin/bash
"$RUSTC" --edition 2021 -Zmir-opt-level=4 -o prog main.rs 2>&1
echo "compile: $?"
./prog 2>&1; echo "run: $?"
