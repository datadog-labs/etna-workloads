#!/bin/bash
# Auto-generated from tests/ui/dyn-compatibility/unsafe-binders-bare-trait-object-next-solver.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver=globally --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
