#!/bin/bash
# Auto-generated from tests/ui/never_type/never_pattern/unused_trait_in_never_pattern_body.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
