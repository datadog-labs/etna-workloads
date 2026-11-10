#!/bin/bash
"$RUSTC" --edition=2021 -Cdebuginfo=0 main.rs -o main 2>&1 | grep -E "panicked|stolen|error" | head -3
echo "compile status: ${PIPESTATUS[0]}"
[ -x main ] && ./main
