#!/bin/bash
"$RUSTC" --edition 2024 --crate-type=rlib -Copt-level=1 -Zvalidate-mir -Zlint-mir -Zmir-opt-level=4 -Zmir-enable-passes=+ReorderBasicBlocks,+ReorderLocals -o out.rlib main.rs 2>&1 | grep -cE "broken MIR in Shim\(AsyncDropGlue"
echo "status: ${PIPESTATUS[0]}"
