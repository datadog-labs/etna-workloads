#!/bin/bash
# Auto-generated from tests/ui/traits/const-traits/overlap-const-with-nonconst.rs#min_spec
cd "$(dirname "$0")"
"$RUSTC" --cfg min_spec -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
