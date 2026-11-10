#!/bin/bash
# Auto-generated from tests/ui/traits/associated_type_bound/116464-invalid-assoc-type-suggestion-in-trait-impl.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
