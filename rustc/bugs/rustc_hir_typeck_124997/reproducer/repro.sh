#!/bin/bash
# Auto-generated from tests/ui/cast/ice-cast-type-with-error-124848.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
