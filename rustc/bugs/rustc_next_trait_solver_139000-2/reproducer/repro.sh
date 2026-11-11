#!/bin/bash
# Auto-generated from tests/ui/traits/trivial-unsized-projection.rs#bad
cd "$(dirname "$0")"
"$RUSTC" --cfg bad -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
