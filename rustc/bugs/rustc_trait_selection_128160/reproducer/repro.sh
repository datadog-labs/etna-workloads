#!/bin/bash
# Auto-generated from tests/ui/auto-traits/assoc-ty.rs#current
cd "$(dirname "$0")"
"$RUSTC" --cfg current -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
