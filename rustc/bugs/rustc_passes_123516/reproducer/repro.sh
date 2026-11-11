#!/bin/bash
# Auto-generated from tests/ui/consts/do-not-ice-on-field-access-of-err-type.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
