#!/bin/bash
# Auto-generated from tests/ui/match/slice-move-out-error-12567.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
