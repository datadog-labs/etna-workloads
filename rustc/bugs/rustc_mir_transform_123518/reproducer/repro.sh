#!/bin/bash
"$RUSTC" --edition=2018 main.rs -o main 2>&1 | head -3
echo "rustc status: ${PIPESTATUS[0]}"
[ -x main ] && ./main
