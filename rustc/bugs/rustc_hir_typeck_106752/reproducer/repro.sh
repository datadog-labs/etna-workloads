#!/bin/bash
# Auto-generated from tests/ui/type/wrong-call-return-type-due-to-generic-arg.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
