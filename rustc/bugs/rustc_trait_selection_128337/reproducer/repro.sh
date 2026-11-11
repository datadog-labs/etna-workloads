#!/bin/bash
# Auto-generated from tests/ui/inference/need_type_info/incompat-call-after-qualified-path-0.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
