#!/bin/bash
# Auto-generated from tests/ui/derives/coercepointee/coerce-pointee-bounds-issue-127647.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
