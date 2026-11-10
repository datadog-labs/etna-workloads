#!/bin/bash
# Auto-generated from tests/ui/lint/invalid_value-polymorphic.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib -Zmir-enable-passes=+InstSimplify-before-inline -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
