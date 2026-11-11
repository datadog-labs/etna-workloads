#!/bin/bash
# Auto-generated from tests/ui/alloc-error/alloc-error-handler-bad-signature-1.rs
cd "$(dirname "$0")"
"$RUSTC" -C panic=abort --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
