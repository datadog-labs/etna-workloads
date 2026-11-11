#!/bin/bash
# Auto-generated from tests/ui/pattern/rfc-3637-guard-patterns/only-resolve-top-level-guard-expr-once-ice-141265.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
