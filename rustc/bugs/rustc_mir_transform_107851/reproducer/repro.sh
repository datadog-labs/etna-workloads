#!/bin/bash
"$RUSTC" --edition 2021 -O -Zmir-opt-level=2 -Zmir-enable-passes=+ScalarReplacementOfAggregates -Zdump-mir=ScalarReplacementOfAggregates -Zdump-mir-dir=d main.rs -o m 2>&1 | head -20
echo "status $?"
for f in d/*f*ScalarReplacementOfAggregates.after.mir; do echo "== f"; grep -nE '_[0-9]+ = (const|move|copy)' "$f"; done
