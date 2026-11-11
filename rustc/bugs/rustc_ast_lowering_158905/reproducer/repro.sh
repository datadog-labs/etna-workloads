#!/bin/bash
# Auto-generated from tests/ui/delegation/constraints-in-generic-args-ice-158812.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
