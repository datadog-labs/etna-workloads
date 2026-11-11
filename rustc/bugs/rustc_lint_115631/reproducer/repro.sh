#!/bin/bash
# Auto-generated from tests/ui/lint/improper-ctypes/lint-option-nonnull-unsized.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
