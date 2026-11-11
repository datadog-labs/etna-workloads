#!/bin/bash
# Auto-generated from tests/ui/feature-gates/unstable-attribute-rejects-already-stable-features.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
