#!/bin/bash
# Auto-generated from tests/ui/assumptions_on_binders/type_relation_binders_inside_solver-3.rs
cd "$(dirname "$0")"
"$RUSTC" -Zassumptions-on-binders --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
