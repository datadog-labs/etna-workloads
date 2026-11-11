#!/bin/bash
"$RUSTC" --edition=2018 --emit=metadata --crate-type=lib main.rs 2>&1 | grep -E '^(error|warning)' | head -5
echo "status: ${PIPESTATUS[0]}"
