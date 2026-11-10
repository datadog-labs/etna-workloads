#!/bin/bash
# Auto-generated from tests/ui/float/f16-into-f32.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
