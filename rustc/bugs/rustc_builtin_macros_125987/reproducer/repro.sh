#!/bin/bash
# Auto-generated from tests/ui/derives/derive-hrtb-for-bare-fn-field-with-lifetime.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }
rm -f prog out.rmeta
