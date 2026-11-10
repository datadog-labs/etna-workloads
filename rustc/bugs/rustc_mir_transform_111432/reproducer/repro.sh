#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib -Zmir-opt-level=2 -Zmir-enable-passes=+CopyProp --emit=mir -o out.mir main.rs 2>&1 | grep -E "panicked|left|right|error" | head -5
echo "status: ${PIPESTATUS[0]}"
