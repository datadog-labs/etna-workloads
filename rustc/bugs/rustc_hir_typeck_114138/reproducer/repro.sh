#!/bin/bash
# Auto-generated from tests/ui/methods/suggest-method-on-call-with-macro-rcvr.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
