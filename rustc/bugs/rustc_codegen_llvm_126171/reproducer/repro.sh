#!/bin/bash
"$RUSTC" --edition 2021 -O --crate-type bin -o out main.rs 2>&1 | sed 's#/[^ ]*/##g'
echo "rustc status: ${PIPESTATUS[0]}"
[ -x out ] && ./out
