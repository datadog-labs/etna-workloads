#!/bin/bash
"$RUSTC" --edition 2021 --emit=metadata --out-dir . --error-format json main.rs 2>&1 | grep -E '^\{|panicked|assertion' | grep -o '"message":"[^"]*"\|panicked\|assertion failed' 
echo "status=${PIPESTATUS[0]}"
