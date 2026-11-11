#!/bin/bash
"$RUSTC" --edition 2021 -Zvalidate-mir -O --crate-type bin main.rs -o main 2>&1 | grep -E "internal compiler error|PtrMetadata" | sed -e "s/^.*internal compiler error: [^ ]* /ICE: /" -e "s/\[[0-9a-f]*\]//"
echo "rustc status: ${PIPESTATUS[0]}"
[ -x main ] && ./main
