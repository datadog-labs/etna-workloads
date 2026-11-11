#!/bin/bash
"$RUSTC" --edition 2021 --crate-type bin --emit=obj -o out.o main.rs 2>&1
echo "status=$?"
