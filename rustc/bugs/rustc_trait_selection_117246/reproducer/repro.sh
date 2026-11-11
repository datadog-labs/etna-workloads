#!/bin/bash
# Auto-generated from tests/ui/associated-type-bounds/do-not-look-at-parent-item-in-suggestion-for-type-param-of-current-assoc-item.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
