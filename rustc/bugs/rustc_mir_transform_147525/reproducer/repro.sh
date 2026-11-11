#!/bin/bash
export RUSTC_BOOTSTRAP=1
"$RUSTC" --edition 2021 -g -Zvalidate-mir -Zmir-opt-level=0 -Zmir-enable-passes=+DestinationPropagation,+DeadStoreElimination-initial --crate-type lib --emit=mir -o out.mir main.rs 2>&1 | grep -E "^error|not in debuginfo|broken MIR" | sed 's/(DefId[^)]*)//'
echo "status=${PIPESTATUS[0]}"
