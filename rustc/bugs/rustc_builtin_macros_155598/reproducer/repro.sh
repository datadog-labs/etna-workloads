#!/bin/bash
"$RUSTC" --edition=2021 -Zunpretty=expanded main.rs 2>&1 | grep -A3 'fn partial_cmp'
echo "status=${PIPESTATUS[0]}"
