#!/bin/bash
# Auto-generated from tests/ui/dyn-compatibility/require-assoc-for-all-super-substs.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
