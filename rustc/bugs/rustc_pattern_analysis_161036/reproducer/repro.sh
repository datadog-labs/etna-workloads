#!/bin/bash
# Auto-generated from tests/ui/rfcs/rfc-2008-non-exhaustive/shadowed-non-exhaustive.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
