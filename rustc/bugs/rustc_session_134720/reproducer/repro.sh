#!/bin/bash
# Auto-generated from tests/ui/linking/crate-type-invalid-flag-error.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type dynlib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
