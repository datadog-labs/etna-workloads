#!/bin/bash
# Auto-generated from tests/ui/traits/normalize/normalize-param-env-missing-implied-bound-1.rs#next
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --cfg next --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
