#!/bin/bash
# Auto-generated from tests/ui/impl-trait/in-trait/check-wf-on-non-defaulted-rpitit.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
