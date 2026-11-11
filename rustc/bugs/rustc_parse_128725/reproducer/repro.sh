#!/bin/bash
"$RUSTC" --edition 2021 main.rs -o m 2>&1
echo "compile=$?"
./m; echo "run=$?"
