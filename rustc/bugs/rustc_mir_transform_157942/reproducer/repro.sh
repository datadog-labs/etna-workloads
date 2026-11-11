#!/bin/bash
# Auto-generated from tests/ui/drop/tail_expr_drop_order-on-coroutine-unwind.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
