#!/bin/bash
# Auto-generated from tests/ui/try-trait/bad-question-mark-on-trait-object.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
