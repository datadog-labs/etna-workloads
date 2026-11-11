#!/bin/bash
# Auto-generated from tests/ui/pattern/check-struct-pat-fields-stability-issue-138319.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
