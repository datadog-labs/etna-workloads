#!/bin/bash
# Auto-generated from tests/ui/rfcs/rfc-0000-never_patterns/ICE-133063-never-arm-no-otherwise-block.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
