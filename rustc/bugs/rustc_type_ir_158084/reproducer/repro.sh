#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/normalize/normalize-assoc-ty-expected-int-var-no-ice-1.rs#next
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --cfg next --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
