#!/bin/bash
# Auto-generated from tests/ui/never_type/never_pattern/never-pattern-as-closure-param-141592.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
