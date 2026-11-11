#!/bin/bash
# Auto-generated from tests/ui/pattern/usefulness/slice_of_empty.rs#exhaustive_patterns
cd "$(dirname "$0")"
"$RUSTC" --cfg exhaustive_patterns -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
