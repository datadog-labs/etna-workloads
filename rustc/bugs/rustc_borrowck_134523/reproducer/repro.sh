#!/bin/bash
# Auto-generated from tests/ui/drop/tail_expr_drop_order-on-thread-local.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
