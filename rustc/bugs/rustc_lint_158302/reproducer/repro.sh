#!/bin/bash
# Auto-generated from tests/ui/lint/lint-type-overflow3.rs
cd "$(dirname "$0")"
"$RUSTC" --emit link -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
