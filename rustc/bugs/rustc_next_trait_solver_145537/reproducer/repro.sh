#!/bin/bash
# Auto-generated from tests/ui/traits/negative-bounds/negative-metasized.rs#current
cd "$(dirname "$0")"
"$RUSTC" -Zinternal-testing-features --cfg current -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
