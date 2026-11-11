#!/bin/bash
# Auto-generated from tests/ui/self/arbitrary_self_types_dispatch_to_vtable.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
