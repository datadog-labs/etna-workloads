#!/bin/bash
# Auto-generated from tests/ui/parser/field-name-in-tuple-struct.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
