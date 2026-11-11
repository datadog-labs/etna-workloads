#!/bin/bash
# Auto-generated from tests/ui/wf/ice-wf-missing-span-in-error-130012.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
