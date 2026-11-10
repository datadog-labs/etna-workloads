#!/bin/bash
# Auto-generated from tests/ui/sanitizer/cfi/sized-associated-ty.rs#cfi
cd "$(dirname "$0")"
"$RUSTC" -C target-feature=-crt-static -C unsafe-allow-abi-mismatch=sanitizer -C codegen-units=1 -C lto -C prefer-dynamic=off -C opt-level=0 -Z sanitizer=cfi --cfg cfi -o prog main.rs 2>&1; echo "rustc exit: $?"
[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }
rm -f prog out.rmeta
