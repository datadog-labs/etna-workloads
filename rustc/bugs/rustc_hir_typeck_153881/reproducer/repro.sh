#!/bin/bash
# Auto-generated from tests/ui/structs/default-field-values/struct-type-parameter-with-default.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
