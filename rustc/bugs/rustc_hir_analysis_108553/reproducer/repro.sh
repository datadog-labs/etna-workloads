#!/bin/bash
# Auto-generated from tests/ui/traits/non_lifetime_binders/late-bound-in-anon-ct.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
