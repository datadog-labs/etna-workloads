#!/bin/bash
"$RUSTC" --edition=2021 --emit=metadata --crate-type=lib -A incomplete_features main.rs 2>&1 | grep -E '^(error|warning)' | head -5
echo "status: ${PIPESTATUS[0]}"
