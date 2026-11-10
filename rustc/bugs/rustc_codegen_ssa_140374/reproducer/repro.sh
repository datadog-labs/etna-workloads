#!/bin/bash
"$RUSTC" --edition=2021 main.rs -o out 2>&1 | grep -E '^error' | head -3
echo "status: ${PIPESTATUS[0]}"
