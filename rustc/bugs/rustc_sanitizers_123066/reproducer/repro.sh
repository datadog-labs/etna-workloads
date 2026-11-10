#!/bin/bash
# Auto-generated from tests/ui/sanitizer/cfi/assoc-ty-lifetime-issue-123053.rs
cd "$(dirname "$0")"
"$RUSTC" -Ccodegen-units=1 -Clto -Ctarget-feature=-crt-static -Zsanitizer=cfi -C unsafe-allow-abi-mismatch=sanitizer --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
