#!/bin/bash
"$RUSTC" --edition=2021 -O main.rs -o main 2>&1 | head -5
echo "compile status: ${PIPESTATUS[0]}"
[ -x main ] && ./main
