#!/bin/bash
# Auto-generated from tests/ui/associated-inherent-types/hr-do-not-blame-outlives-static-ice.rs
cd "$(dirname "$0")"
"$RUSTC" -Zdeduplicate-diagnostics=yes -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
