#!/bin/bash
# Auto-generated from tests/ui/consts/do-not-ice-long-constant-evaluation-in-for-loop.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
