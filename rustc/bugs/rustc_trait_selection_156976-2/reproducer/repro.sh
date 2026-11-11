#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/normalize/param_env-region-constraints-ambiguity.rs#next
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --cfg next --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
