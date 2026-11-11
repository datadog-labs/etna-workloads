#!/bin/bash
# Auto-generated from tests/ui/stats/input-stats.rs
cd "$(dirname "$0")"
"$RUSTC" -Zinput-stats --edition 2015 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
