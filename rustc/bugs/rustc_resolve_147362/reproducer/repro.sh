#!/bin/bash
# Auto-generated from tests/ui/traits/associated_type_bound/assoc-type-maybe-trait-147356.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
