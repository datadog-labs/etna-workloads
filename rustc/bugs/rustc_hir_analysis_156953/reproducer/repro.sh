#!/bin/bash
# Auto-generated from tests/ui/delegation/generics/generics-gen-args-errors.rs
cd "$(dirname "$0")"
"$RUSTC" -Z deduplicate-diagnostics=yes -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
