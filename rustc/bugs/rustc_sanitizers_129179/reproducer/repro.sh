#!/bin/bash
# Auto-generated from tests/ui/sanitizer/cfi/transparent-has-regions.rs
cd "$(dirname "$0")"
"$RUSTC" -Ccodegen-units=1 -Clto -Ctarget-feature=-crt-static -Zsanitizer=cfi -C unsafe-allow-abi-mismatch=sanitizer -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
