#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --emit=mir -Zdump-mir=built -Zdump-mir-dir=out main.rs -o out.mir 2>&1 | grep -E "internal compiler error|^error" | head -3
echo "status ${PIPESTATUS[0]}"
