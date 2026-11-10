#!/bin/bash
# Auto-generated from tests/ui/never_type/regress/suggestion-ice-132517.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
