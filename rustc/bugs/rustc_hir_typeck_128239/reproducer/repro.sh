#!/bin/bash
# Auto-generated from tests/ui/methods/dont-ice-on-object-lookup-w-error-region.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
