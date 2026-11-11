#!/bin/bash
# Auto-generated from tests/ui/splat/splat-mangling.rs#default
cd "$(dirname "$0")"
"$RUSTC" -C opt-level=0 --cfg default -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
