#!/bin/bash
"$RUSTC" --edition 2021 -Zmir-enable-passes=+Inline --emit=mir -o out.mir lib.rs 2>&1 | grep -E "panicked|stolen|internal compiler" | head -3
echo "status: ${PIPESTATUS[0]}"
