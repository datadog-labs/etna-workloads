#!/bin/bash
# Auto-generated from tests/ui/closures/2229_closure_analysis/match/if-let-guards-errors.rs#e2018
cd "$(dirname "$0")"
"$RUSTC" --edition 2018 --cfg e2018 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
