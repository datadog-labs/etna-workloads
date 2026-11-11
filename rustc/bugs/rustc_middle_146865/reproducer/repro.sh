#!/bin/bash
# Auto-generated from tests/ui/sanitizer/kcfi-c-variadic.rs
cd "$(dirname "$0")"
"$RUSTC" -Zsanitizer=kcfi -Cpanic=abort -Cunsafe-allow-abi-mismatch=sanitizer -o prog main.rs 2>&1; echo "rustc exit: $?"
[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }
rm -f prog out.rmeta
