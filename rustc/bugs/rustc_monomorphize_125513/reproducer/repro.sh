#!/bin/bash
# Auto-generated from tests/ui/codegen/mono-impossible-drop.rs#current
cd "$(dirname "$0")"
"$RUSTC" -Clink-dead-code=on --crate-type=lib --cfg current -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
