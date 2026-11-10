#!/bin/bash
# Auto-generated from tests/ui/lint/lint-missing-doc-test.rs
cd "$(dirname "$0")"
"$RUSTC" --test --crate-type=lib --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
