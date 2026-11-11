#!/bin/bash
# Auto-generated from tests/ui/parser/recover/unicode-double-equals-recovery.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
