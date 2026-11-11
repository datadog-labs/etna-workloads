#!/bin/bash
# Auto-generated from tests/ui/traits/associated_type_bound/assoc-type-bounds-with-the-same-name-with-lacking-generic-arg-148121.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
