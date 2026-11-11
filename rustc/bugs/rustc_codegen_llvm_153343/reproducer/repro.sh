#!/bin/bash
"$RUSTC" --edition 2021 -C opt-level=2 main.rs -o m 2>&1
echo "compile=$?"
./m; echo "run=$?"
