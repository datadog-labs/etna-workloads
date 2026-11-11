#!/bin/bash
# Auto-generated from tests/ui/explicit-tail-calls/unsupported-abi/rust-call.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
