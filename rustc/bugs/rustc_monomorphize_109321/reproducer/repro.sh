#!/bin/bash
# Auto-generated from tests/ui/codegen/mono-impossible-2.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib -Clink-dead-code=on -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
