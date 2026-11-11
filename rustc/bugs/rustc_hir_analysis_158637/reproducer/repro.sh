#!/bin/bash
# Auto-generated from tests/ui/associated-inherent-types/next-solver-unsatisfied-bounds-inherent-tait.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver=globally -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
