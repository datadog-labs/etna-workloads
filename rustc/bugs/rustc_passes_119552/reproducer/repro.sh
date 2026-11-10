#!/bin/bash
# Auto-generated from tests/ui/lint/dead-code/pub-field-in-priv-mod.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
