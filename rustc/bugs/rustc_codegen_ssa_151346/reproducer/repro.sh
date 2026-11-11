#!/bin/bash
"$RUSTC" --edition 2021 -O -A internal_features main.rs -o main 2>&1
echo "compile status: $?"
[ -x main ] && ./main; echo "run status: $?"
