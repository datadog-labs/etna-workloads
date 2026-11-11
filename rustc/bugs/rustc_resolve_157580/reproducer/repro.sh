#!/bin/bash
# Auto-generated from tests/ui/resolve/import-suggestion-duplicated-importing-same-item.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
