#!/bin/bash
# Auto-generated from tests/ui/linking/export-executable-symbols.rs
cd "$(dirname "$0")"
"$RUSTC" -Ctarget-feature=-crt-static -Zexport-executable-symbols --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }
rm -f prog out.rmeta
