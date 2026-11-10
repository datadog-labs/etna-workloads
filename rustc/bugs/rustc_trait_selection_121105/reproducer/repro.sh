#!/bin/bash
"$RUSTC" --edition 2021 --crate-type bin -o out.bin main.rs 2>&1 | grep -E "^error|required for|help:"
echo "exit ${PIPESTATUS[0]}"
