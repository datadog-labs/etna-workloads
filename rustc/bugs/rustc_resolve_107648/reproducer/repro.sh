#!/bin/bash
"$RUSTC" --crate-type lib --emit metadata --out-dir . main.rs 2>&1 | head -5 | cut -c1-100
echo "status: ${PIPESTATUS[0]}"
