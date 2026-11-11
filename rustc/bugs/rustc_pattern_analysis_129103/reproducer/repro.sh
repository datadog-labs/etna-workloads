#!/bin/bash
# Auto-generated from tests/ui/pattern/usefulness/empty-types.rs#never_pats
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 --cfg never_pats -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
