#!/bin/bash
# Auto-generated from tests/ui/impl-trait/member-constraints/placeholders_lift_to_static.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
