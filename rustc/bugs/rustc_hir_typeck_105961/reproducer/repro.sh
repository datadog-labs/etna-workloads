#!/bin/bash
# Auto-generated from tests/ui/associated-inherent-types/not-found-unsatisfied-bounds-in-multiple-impls.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
