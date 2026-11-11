#!/bin/bash
# Auto-generated from tests/ui/const-generics/defaults/doesnt_infer.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
