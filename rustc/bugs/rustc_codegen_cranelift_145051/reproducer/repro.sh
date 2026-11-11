#!/bin/bash
# Auto-generated from tests/codegen-llvm/sanitizer/cfi/external_weak_symbols.rs
cd "$(dirname "$0")"
"$RUSTC" -Clinker-plugin-lto -Copt-level=0 -Zsanitizer=cfi -Ctarget-feature=-crt-static -C unsafe-allow-abi-mismatch=sanitizer --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
