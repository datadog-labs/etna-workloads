#!/bin/bash
# Auto-generated from tests/ui/associated-types/param-env-shadowing-suggestion-no-ice-on-missing-assoc-value.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
