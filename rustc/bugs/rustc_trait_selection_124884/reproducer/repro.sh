#!/bin/bash
# Auto-generated from tests/ui/generic-associated-types/static-lifetime-tip-with-default-type.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
