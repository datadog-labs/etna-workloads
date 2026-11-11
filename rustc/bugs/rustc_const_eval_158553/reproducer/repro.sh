#!/bin/bash
"$RUSTC" --edition 2021 --emit metadata --crate-type bin main.rs -o out.rmeta 2>&1 | head -20
echo "status: ${PIPESTATUS[0]}"
