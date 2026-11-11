#!/bin/bash
# Auto-generated from tests/ui/delegation/self-ty-ice-156388.rs
cd "$(dirname "$0")"
"$RUSTC" -Z deduplicate-diagnostics=yes -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
