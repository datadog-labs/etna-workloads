#!/bin/bash
# Auto-generated from tests/ui/pattern/manually-drop-dangling-ref.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
