#!/bin/bash
rm -f out
"$RUSTC" --edition=2018 --crate-type=bin -o out main.rs 2>&1 | grep -E "^(error|thread|.*panicked)" | head -5
echo "status=${PIPESTATUS[0]}"
[ -x out ] && ./out && echo ran
