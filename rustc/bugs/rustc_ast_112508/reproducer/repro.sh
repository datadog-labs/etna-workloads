#!/bin/bash
# Auto-generated from tests/ui/dropck/explicit-drop-bounds.rs#bad1
cd "$(dirname "$0")"
"$RUSTC" --cfg bad1 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
