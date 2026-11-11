#!/bin/bash
"$RUSTC" --edition=2021 --crate-type=bin main.rs -o out 2>&1 | grep -E "panicked|error" | head -3
echo "rustc status: ${PIPESTATUS[0]}"
[ -x out ] && ./out; echo "run: $?"
