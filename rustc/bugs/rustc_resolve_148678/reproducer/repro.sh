#!/bin/bash
# Auto-generated from tests/ui/annotate-snippet/missing-type.rs
cd "$(dirname "$0")"
"$RUSTC" --error-format human --edition 2015 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
