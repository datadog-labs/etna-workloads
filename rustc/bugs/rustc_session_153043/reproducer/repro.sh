#!/bin/bash
# Auto-generated from tests/ui/panic-runtime/bad-panic-flag2.rs
cd "$(dirname "$0")"
"$RUSTC" -C panic -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
