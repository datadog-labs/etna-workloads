#!/bin/bash
# Auto-generated from tests/ui/did_you_mean/collect-without-into-iter-call.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
