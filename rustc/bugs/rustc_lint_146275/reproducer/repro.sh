#!/bin/bash
"$RUSTC" --edition 2021 --emit metadata --crate-type bin -o out.rmeta main.rs 2>&1 | tail -n 5
echo "status: ${PIPESTATUS[0]}"
