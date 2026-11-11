#!/bin/bash
# Auto-generated from tests/ui/privacy/issue-111220-2-tuple-struct-fields-projection.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
