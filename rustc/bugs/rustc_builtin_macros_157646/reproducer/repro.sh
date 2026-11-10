#!/bin/bash
# Auto-generated from tests/ui/lint/dead-code/imported_main_dead_code_under_test.rs
cd "$(dirname "$0")"
"$RUSTC" --test --crate-type=lib --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
