#!/bin/bash
# Auto-generated from tests/ui/diagnostic_namespace/do_not_recommend/malformed-diagnostic-attributes-if-expression.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
