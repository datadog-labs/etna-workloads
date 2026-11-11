#!/bin/bash
"$RUSTC" --edition 2021 -Znext-solver --emit metadata --crate-type bin -A warnings -o out.rmeta main.rs 2>&1 | cut -c1-80 | head -3
echo "status: ${PIPESTATUS[0]}"
