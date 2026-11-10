#!/bin/bash
# Auto-generated from tests/ui/associated-types/associated-types-invalid-trait-ref-issue-18865.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
