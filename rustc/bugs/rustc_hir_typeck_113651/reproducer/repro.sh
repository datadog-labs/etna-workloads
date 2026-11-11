#!/bin/bash
# Auto-generated from tests/ui/inference/need_type_info/infer-var-for-self-param.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
