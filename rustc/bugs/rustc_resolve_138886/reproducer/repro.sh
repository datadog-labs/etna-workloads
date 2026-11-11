#!/bin/bash
"$RUSTC" --edition 2021 --emit metadata --error-format=json main.rs 2>&1 | grep -o '"suggested_replacement":"[^"]*"'
echo "status ${PIPESTATUS[0]}"
