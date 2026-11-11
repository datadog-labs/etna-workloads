#!/bin/bash
# Auto-generated from tests/ui/codegen/mono-impossible.rs
cd "$(dirname "$0")"
"$RUSTC" -Clink-dead-code=on --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
