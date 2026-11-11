#!/bin/bash
# Auto-generated from tests/codegen-llvm/sanitizer/cfi/emit-type-metadata-trait-objects.rs
cd "$(dirname "$0")"
"$RUSTC" -Clto -Cno-prepopulate-passes -Copt-level=0 -Ctarget-feature=-crt-static -Zsanitizer=cfi -C unsafe-allow-abi-mismatch=sanitizer --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
