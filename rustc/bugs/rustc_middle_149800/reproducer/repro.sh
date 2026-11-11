#!/bin/bash
"$RUSTC" --edition=2018 --crate-type=lib --emit=metadata -o out.rmeta main.rs 2>&1 | grep -E '^(error|warning)' | sed 's/Alias.*//'
echo "status: ${PIPESTATUS[0]}"
